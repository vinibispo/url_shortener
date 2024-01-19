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
      description: page_meta.description,
      image: '/apple-touch-icon.png'
    }

    page_meta.link :apple_touch_icon, sizes: '180x180', href: '/apple-touch-icon.png'

    page_meta.link :icon, type: 'image/png', sizes: '32x32', href: '/favicon-32x32.png'

    page_meta.link :icon, type: 'image/png', sizes: '16x16', href: '/favicon-16x16.png'

    page_meta.link :manifest, href: '/site.webmanifest'
  end
end
