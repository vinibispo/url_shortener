case Rails.env
when "development"
  default_url_options = { host: "localhost", port: ENV.fetch("PORT", 3000) }
  Rails.application.routes.default_url_options = default_url_options
  Rails.application.config.action_mailer.default_url_options = default_url_options

  when "test"
  default_url_options = { host: "localhost", port: Capybara.server_port }
  Rails.application.routes.default_url_options = default_url_options
  Rails.application.config.action_mailer.default_url_options = default_url_options
  when "production"
  default_url_options = { host: ENV.fetch("HOST", "urlcrew.co") }
  Rails.application.routes.default_url_options = default_url_options
  Rails.application.config.action_mailer.default_url_options = default_url_options
end
