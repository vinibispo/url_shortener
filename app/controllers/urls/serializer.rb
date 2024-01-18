Urls::Serializer = Data.define(:short, :original, :date) do
  def formatted_date
    I18n.l(date, format: '%b %e, %Y')
  end

  def timestamp
    I18n.l(date, format: '%F')
  end

  def model_name
    OpenStruct.new(param_key: "link")
  end

  def to_key
    [short]
  end

  def short_url
    Rails.application.routes.url_helpers.short_url(short)
  end
end
