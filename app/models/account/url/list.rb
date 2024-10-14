class Account
  class Url::List
    private attr_accessor :account_id

    def initialize(account_id:)
      self.account_id = account_id
    end

    def call
      urls = fetch_urls

      [ :ok, urls ]
    end

    private

    def fetch_urls
      urls_by_account = ::Url.where(account_id: account_id)

      urls_by_account.order(created_at: :desc)
    end
  end
end
