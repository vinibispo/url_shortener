class Account
  class Url::Generate
    private attr_accessor :original_url, :short_url, :account_id
    def initialize(url:, account_id:, short_url: nil)
      self.original_url = url
      self.short_url = short_url
      self.account_id = account_id
    end

    def call
      link = ::Url.new(original_url:, account_id:)
      link.short_url = short_url.presence || generate_short_url

      link.save if link.errors.empty?

      if link.errors.any?
        link.short_url = short_url.presence
        return [:error, link]
      end

      [:ok, link]
    end

    private

    def generate_short_url
      loop do
        short_url = SecureRandom.hex(3)
        break short_url unless ::Url.exists?(short_url:)
      end
    end
  end
end
