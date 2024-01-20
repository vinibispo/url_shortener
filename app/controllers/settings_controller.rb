class SettingsController < ApplicationController
  def change_locale
    locale = params[:locale].to_s.strip.to_sym

    if I18n.available_locales.include?(locale)
      cookies.permanent[:locale] = locale
      I18n.locale = locale
    end

    redirect_to root_path
  end
end
