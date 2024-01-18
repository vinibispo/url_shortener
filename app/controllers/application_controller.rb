class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :set_meta

  def set_meta
    page_meta.tag :author, 'Vinícius Bispo'

    page_meta.tag :copyright, 'UrlCrew Inc.'

    page_meta.tag :og, {
      title: 'UrlCrew',
      type: 'website',
      url: 'https://urlcrew.co',
      description: page_meta.description
    }
  end
end
