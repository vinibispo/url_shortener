case Rails.env
when "development"
  Rails.application.configure do
    config.action_mailer.perform_deliveries = true
    config.action_mailer.smtp_settings = { port: 1025 }
  end
  when "test"
    Rails.application.configure do
      config.action_mailer.delivery_method = :test
      config.action_mailer.raise_delivery_errors = true
    end
  when "production"
    Rails.application.configure do
      config.action_mailer.delivery_method = :smtp
      config.action_mailer.smtp_settings = {
        address: ENV["SMTP_ADDRESS"],
        port: ENV["SMTP_PORT"],
        user_name: ENV["SMTP_USERNAME"],
        password: ENV["SMTP_PASSWORD"],
        authentication: ENV["SMTP_AUTHENTICATION"],
        enable_starttls_auto: true
      }
    end
end
