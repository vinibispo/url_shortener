class Account
  class Url::Remove
    private attr_accessor :short_url, :account_id

    def initialize(short_url:, account_id:)
      self.short_url = short_url
      self.account_id = account_id
    end

    def call
      case Url::Fetch.new(short_url:, account_id:).call
      in [:ok, url]
        url.destroy
        [:ok, url]
      in [:not_found, url]
        [:not_found, url]
      end
    end
  end
end
