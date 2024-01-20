Rails.application.configure do
  config.i18n.available_locales = %i[en pt-br]
  config.i18n.default_locale = :en
  config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.yml")]
  # config.i18n.fallbacks = true
end
