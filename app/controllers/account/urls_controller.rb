class Account
  class UrlsController < BaseController
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
        flash.now[:notice] = "Shortened link: #{short_url(link.short_url)}"
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.replace('account_url_form', partial: 'account/urls/form', locals: { url: ::Url.new }),
              turbo_stream.prepend('account_urls', partial: 'account/urls/link', locals: { link: ToSerialize[link] })
            ]
          end
        end
      in [:error, link]
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace('account_url_form', partial: 'account/urls/form', locals: { url: link })
          end
        end
      end
    end

    private

    def url_params
      params.require(:url).permit(:original_url, :short_url)
    end
  end
end
