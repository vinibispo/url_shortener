require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  test "visiting the home" do
    visit root_url

    fill_in "Enter your link", with: "https://google.com"

    click_on "Shorten"

    assert_text "Shortened link"
  end

  test "visiting the home and seeing your old link" do
    visit root_url

    fill_in "Enter your link", with: "https://google.com"

    click_on "Shorten"

    assert_text "Shortened link"

    assert_text "https://google.com"
  end

  test "failing filling the link" do
    visit root_url

    fill_in "Enter your link", with: ""

    click_on "Shorten"

    assert_text "can't be blank"
  end

  test "failing filling the link with invalid url" do
    visit root_url

    fill_in "Enter your link", with: "foobar"

    click_on "Shorten"

    assert_text "invalid"
  end

  test "failing filling the link with blank, and after with invalid url" do
    visit root_url

    fill_in "Enter your link", with: ""

    click_on "Shorten"

    assert_text "can't be blank"


    fill_in "Enter your link", with: "foobar"

    click_on "Shorten"


    refute_text "can't be blank"

    assert_text "invalid"
  end

  test "visiting the home and seeing your link small when the link is so big" do
    visit root_url
    url = "https://www.amazon.com/Bluetooth-Headphones-Wireless-Waterproof-Earphones/dp/B0C3W4MNN1/ref=sr_1_6?keywords=earphones&qid=1702384526&sr=8-6"

    fill_in "Enter your link", with: url

    click_on "Shorten"

    assert_text "Shortened link"

    refute_text url

    assert_text url[0..10]
  end

  test "visiting the home and testing the blocklist" do
    visit root_url

    url = File.readlines(Rails.root.join('lib', 'files', 'blocklist.txt')).map(&:chomp).first

    fill_in "Enter your link", with: url

    click_on "Shorten"

    assert_text "Original url contains blocked words"
  end

  test "visiting the home and testing the blocklist with more words" do
    visit root_url

    url = File.readlines(Rails.root.join('lib', 'files', 'blocklist.txt')).map(&:chomp).second

    fill_in "Enter your link", with: "https://#{url}/prohibited"

    click_on "Shorten"

    assert_text "Original url contains blocked words"
  end

  # test "visiting the home and changing the locale" do
  #   visit root_url
  #
  #   select "Português (Brasil)", from: "locale"
  #
  #   assert_text "Encurte Seus Links Longos :)"
  # end

  # I need to prepare chrome to add permissions to the clipboard
  # test "visiting the home and copying an url" do
  #   visit root_url
  #
  #   url = "https://google.com"
  #
  #   fill_in "Enter your link", with: url
  #
  #   click_on "Shorten"
  #
  #   click_button '📋'
  #
  #   link = Url.last
  #
  #   execute_script("document.execCommand('paste')")
  #
  #   # Check if the clipboard has the short url
  #   clipboard_value = page.evaluate_script("navigator.clipboard.readText()")
  #   assert_equal Rails.application.routes.url_helpers.short_url(link.short_url), clipboard_value
  # end
end
