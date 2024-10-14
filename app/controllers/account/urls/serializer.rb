Account::Urls::Serializer = Data.define(:short, :original, :date, :clicks, :expired_at) do
  def formatted_date
    I18n.l(date, format: "%b %e, %Y")
  end

  def timestamp
    I18n.l(date, format: "%F")
  end

  def expired?
    return false unless expired_at

    expired_at < Time.zone.now
  end

  def expired
    return I18n.t("flash.url.false") unless expired_at

    return "#{I18n.t('flash.url.false')}, #{I18n.l(expired_at.to_date, format: :default)}" if expired_at > Time.zone.now

    "#{I18n.t('flash.url.true')}, #{I18n.l(expired_at.to_date, format: :default)}"
  end

  def short_url
    Rails.application.routes.url_helpers.short_url(short)
  end
end
