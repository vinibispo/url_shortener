Account::Urls::Serializer = Data.define(:short, :original, :date, :clicks) do
  def formatted_date
    date.strftime("%b %e, %Y")
  end

  def timestamp
    date.strftime("%F")
  end

  def short_url
    Rails.application.routes.url_helpers.short_url(short)
  end
end