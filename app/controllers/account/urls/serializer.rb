Account::Urls::Serializer = Data.define(:short, :original, :date, :clicks, :expired_at) do
  def formatted_date
    date.strftime("%b %e, %Y")
  end

  def timestamp
    date.strftime("%F")
  end

  def expired
    return 'No' unless expired_at

    return "No, #{expired_at.strftime("%F")}" if expired_at > Time.zone.now

    "Yes, #{expired_at.strftime('%F')}"
  end

  def short_url
    Rails.application.routes.url_helpers.short_url(short)
  end
end
