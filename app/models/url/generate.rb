class Url::Generate
  private attr_accessor :original_url, :short_url
  def initialize(url:, short_url: nil)
    self.original_url = url
    self.short_url = short_url
  end

  def call
    link = Url.new(original_url:)
    link.short_url = short_url || generate_short_url

    link.save

    if link.errors.any?
      return [:error, link]
    end

    [:ok, link]
  end

  private

  def generate_short_url
    loop do
      short_url = SecureRandom.hex(3)
      break short_url unless Url.where(short_url:).exists?
    end
  end
end
