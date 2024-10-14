class Url::FetchByShort
  private attr_accessor :short_url
  def initialize(short_url:)
    self.short_url = short_url
  end

  def call
    link = Url.find_by(short_url:)

    return [ :not_found, nil ] unless link.present?

    return [ :expired, link ] if link.expired_at.present? && link.expired_at < Time.zone.now

    if link.account_id.present?
      link.increment!(:clicks)
    end

    [ :ok, link ]
  end
end
