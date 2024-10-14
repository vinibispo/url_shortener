require "test_helper"

class UrlTest < ActiveSupport::TestCase
  test "#valid? returns false when there is no original_url" do
    url = Url.new

    assert_not url.valid?
  end

  test "#valid? returns false when there is no original_url in url format" do
    url = Url.new(original_url: "foobar", short_url: "hex")

    assert_not url.valid?
  end

  test "#valid? returns false when there is no short_url" do
    url = Url.new(original_url: "https://google.com")

    assert_not url.valid?
  end

  test "#valid? returns true when everything is ok with the url record" do
    url = Url.new(original_url: "https://google.com", short_url: SecureRandom.hex(3))

    assert url.valid?
  end

  test "#valid? returns false when url is already shortened" do
    url = Url.new(original_url: "https://google.com", short_url: SecureRandom.hex(3))
    url.save

    shortened_url = Rails.application.routes.url_helpers.short_url(url.short_url)
    url2 = Url.new(original_url: shortened_url, short_url: SecureRandom.hex(3))

    assert_not url2.valid?
  end
end
