class Account
  class Url::Fetch
    private attr_accessor :short_url, :account_id

    def initialize(short_url:, account_id:)
      self.short_url = short_url
      self.account_id = account_id
    end

    def call
      url = ::Url.find_by(short_url:, account_id:)
      return [:ok, url] if url.present?

      [:not_found, url]
    end
  end
end
