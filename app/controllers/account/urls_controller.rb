class Account
  class UrlsController < Account::BaseController
    ToSerialize = lambda do |url|
      Urls::Serializer.new(original: url.original_url, short: url.short_url, date: url.created_at, clicks: url.clicks)
    end

    private_constant :ToSerialize
    def index
      _, urls = Url::List.new(account_id: current_account.id).call
      @pagy, urls = pagy(urls)
      url = ::Url.new

      render locals: { links: urls.map(&ToSerialize), url: }
    end

    def create
      input = { url: url_params[:original_url], short_url: url_params[:short_url], account_id: current_account.id }

      case Url::Generate.new(**input).call
      in [:ok, link]
        flash[:notice] = "Shortened link: #{short_url(link.short_url)}"
        redirect_to account_root_path
      in [:error, link]
        _, urls = Url::List.new(account_id: current_account.id).call
        @pagy, urls = pagy(urls)
        render :index, locals: { url: link, links: urls.map(&ToSerialize) }, status: :unprocessable_entity
      end
    end

    private

    def url_params
      params.require(:url).permit(:original_url, :short_url)
    end
  end
end
