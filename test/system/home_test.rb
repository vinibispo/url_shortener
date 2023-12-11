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
end
