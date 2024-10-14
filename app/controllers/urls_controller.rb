class UrlsController < ApplicationController
  ToSerialize = lambda do |url|
    Urls::Serializer.new(original: url.original_url, short: url.short_url, date: url.created_at)
  end

  before_action :redirect_to_dashboard, only: :index

  private_constant :ToSerialize
  def index
    url = Url.new
    _, urls = Url::List.call
    @pagy, links = pagy(urls, link_extra: 'data-turbo-action="advance"')
    page_meta.tag :robots, "index, follow"

    render locals: { url:, links: links.map(&ToSerialize) }
  end

  def create
    input = { url: url_params[:original_url], short_url: url_params[:short_url] }
    url = Url::Generate.new(**input).call

    case url
    in [:ok, link]
      flash.now[:notice] = I18n.t("flash.url.shortened", url: short_url(link.short_url, locale: nil))
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("url_form", partial: "urls/form", locals: { url: Url.new }),
            turbo_stream.prepend("urls", partial: "urls/link", locals: { link: ToSerialize[link] })
          ]
        end
      end
    in [:error, link]
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("url_form", partial: "urls/form", locals: { url: link }), status: :unprocessable_entity
        end
      end
    end
  end

  def redirect
    input = { short_url: params[:short_url] }
    url = Url::FetchByShort.new(**input).call
    page_meta.tag :robots, "noindex, nofollow"

    case url
    in [:ok, link]
      redirect_to link.original_url, allow_other_host: true
    in [:not_found, message]
        flash[:notice] = message
        redirect_to "/404"
    in [:expired, link]
      flash[:notice] = I18n.t("flash.url.expired")
      redirect_to "/404"
    end
  end

  private

  def url_params
    params.require(:url).permit(:original_url, :short_url)
  end

  def redirect_to_dashboard
    redirect_to account_root_path if current_account
  end
end
