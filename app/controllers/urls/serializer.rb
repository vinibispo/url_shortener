Urls::Serializer = Data.define(:short, :original, :date) do
  def formatted_date
    date.strftime("%b %e, %Y")
  end

  def timestamp
    date.strftime("%F")
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
