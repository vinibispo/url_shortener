class Account
  class Url::Update
    private attr_accessor :original_url, :old_short_url, :short_url, :account_id, :expired_at

    def initialize(url:, old_short_url:, short_url:, account_id:, expired_at: nil)
      self.old_short_url = old_short_url
      self.original_url = url
      self.short_url = short_url
      self.account_id = account_id
      self.expired_at = expired_at
    end

    def call
      case Url::Fetch.new(short_url: old_short_url, account_id:).call
      in [:ok, url]
        url.update(original_url:, short_url:, expired_at:)
        return [:ok, url] if url.save

        [:error, url]
      in [:not_found, url]
        [:not_found, url]
      end
    end
  end
end
