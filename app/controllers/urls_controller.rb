class UrlsController < ApplicationController
  ToSerialize = lambda do |url|
    Urls::Serializer.new(original: url.original_url, short: url.short_url, date: url.created_at)
  end
  private_constant :ToSerialize
  def index
    url = Url.new
    # implement pagination using pagy
    #
    @pagy, links = pagy(Url.order(created_at: :desc))

    render locals: { url:, links: links.map(&ToSerialize) }
  end

  def create
    input = { url: url_params[:original_url], short_url: url_params[:short_url] }
    url = Url::Generate.new(**input).call

    case url
    in [:ok, link]
      flash[:notice] = "Shortened link: #{short_url(link.short_url)}"
      redirect_to root_path
    in [:error, link]
      @pagy, links = pagy(Url.order(created_at: :desc))
      render :index, locals: { url: link, links: links.map(&ToSerialize) }, status: :unprocessable_entity
    end
  end

  def redirect
    input = { short_url: params[:short_url] }
    url = Url::FetchByShort.new(**input).call

    case url
    in [:ok, link]
      redirect_to link.original_url, allow_other_host: true
    in [:not_found, message]
        flash[:notice] = message
        redirect_to "/404"
    end
  end

  private

  def url_params
    params.require(:url).permit(:original_url, :short_url)
  end

end
