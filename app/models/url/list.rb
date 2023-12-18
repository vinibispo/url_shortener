module Url::List
  extend self
  def call
    urls = fetch_urls

    [:ok, urls]
  end

  private

  def fetch_urls
    urls_without_account = ::Url.where(account_id: nil)

    urls_without_account.order(created_at: :desc)
  end
end
