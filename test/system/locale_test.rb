require "application_system_test_case"
class LocaleTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  I18n.available_locales.each do |locale|
    test "visiting all the pages and make sure there's no missing translations when locale is #{locale}" do
      visit root_url(locale:)

      assert_no_selector "span.translation_missing"

      click_on "Log In"

      assert_no_selector "span.translation_missing"

      click_on i18n_helper("devise.shared.links.sign_up", locale:)

      assert_no_selector "span.translation_missing"

      click_on i18n_helper("devise.shared.links.sign_in", locale:)

      sleep 1

      assert_no_selector "span.translation_missing"

      click_on i18n_helper("devise.shared.links.forgot_your_password", locale:)

      assert_no_selector "span.translation_missing"

      click_on "UrlCrew"

      account = Account.create(email: "test@email.com", password: "password", username: "test")

      sign_in account

      assert_no_selector "span.translation_missing"

      visit root_url(locale:)

      assert_no_selector "span.translation_missing"
    end
  end

  test "visiting the login url when changing the locale" do
    visit new_account_session_url

    select "Português (Brasil)", from: "locale"

    sleep 1

    assert_equal current_path, new_account_session_path(locale: 'pt-br')
  end

  def i18n_helper(string, locale: I18n.locale)
    I18n.t(string, locale:)
  end
end
