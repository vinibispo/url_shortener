case Rails.env
when "development"
  default_url_options = { host: "localhost", port: ENV.fetch("PORT", 3000) }
  Rails.application.routes.default_url_options = default_url_options
  when "test"
  default_url_options = { host: "localhost", port: Capybara.server_port }
  Rails.application.routes.default_url_options = default_url_options
end
