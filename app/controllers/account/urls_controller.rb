class Account
  class UrlsController < BaseController
    ToSerialize = lambda do |url|
      Urls::Serializer.new(
        original: url.original_url,
        short: url.short_url,
        date: url.created_at,
        clicks: url.clicks,
        expired_at: url.expired_at
      )
    end

    private_constant :ToSerialize
    def index
      _, urls = Url::List.new(account_id: current_account.id).call
      @pagy, urls = pagy(urls)
      url = ::Url.new

      render locals: { links: urls.map(&ToSerialize), url: }
    end

    def create
      input = {
        url: url_params[:original_url],
        short_url: url_params[:short_url],
        expired_at: url_params[:expired_at],
        account_id: current_account.id
      }

      case Url::Generate.new(**input).call
      in [:ok, link]
        flash.now[:notice] = "Shortened link: #{short_url(link.short_url)}"
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.update('account_url_form', partial: 'account/urls/form', locals: { url: ::Url.new }),
              turbo_stream.prepend('account_urls', partial: 'account/urls/link', locals: { link: ToSerialize[link] })
            ]
          end
        end
      in [:error, link]
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.update(
              'account_url_form', partial: 'account/urls/form', locals: { url: link }
            )
          end
        end
      end
    end

    def edit
      case Url::Fetch.new(short_url: params[:short_url], account_id: current_account.id).call
      in [:ok, url]
        render locals: { url: }
      in [:not_found, url]
        flash[:alert] = "Url not found"
        redirect_to account_root_path
      end
    end

    def update
      input = {
        url: url_params[:original_url],
        old_short_url: params[:short_url],
        short_url: url_params[:short_url],
        account_id: current_account.id,
        expired_at: url_params[:expired_at]
      }

      case Url::Update.new(**input).call
      in [:ok, link]
        flash[:notice] = "Shortened link: #{short_url(link.short_url)}"
        redirect_to account_root_path
      in [:error, link]
        render :edit, locals: { url: link }
      in [:not_found, link]
        flash[:alert] = "Url not found"
        redirect_to account_root_path
      end
    end

    def destroy
      case Url::Remove.new(short_url: params[:short_url], account_id: current_account.id).call
      in [:ok, link]
        flash[:notice] = "Url removed"
        redirect_to account_root_path
      in [:not_found, link]
        flash[:alert] = "Url not found"
        redirect_to account_root_path
      end
    end

    private

    def url_params
      params.require(:url).permit(:original_url, :short_url, :expired_at)
    end
  end
end
