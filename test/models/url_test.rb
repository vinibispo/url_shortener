require "test_helper"

class UrlTest < ActiveSupport::TestCase
  test "#valid? returns false when there is no original_url" do
    url = Url.new
    
    refute url.valid?
  end

  test "#valid? returns false when there is no original_url in url format" do
    url = Url.new(original_url: "foobar", short_url: "hex")

    refute url.valid?
  end

  test "#valid? returns false when there is no short_url" do
    url = Url.new(original_url: "https://google.com")

    refute url.valid?
  end

  test "#valid? returns true when everything is ok with the url record" do
    url = Url.new(original_url: "https://google.com", short_url: SecureRandom.hex(3))

    assert url.valid?
  end
end
