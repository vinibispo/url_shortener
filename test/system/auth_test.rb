require "application_system_test_case"

class AuthTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper
  setup do
    Capybara.default_max_wait_time = 10
  end
  test "visiting the root" do
    visit root_url

    assert_equal current_path, root_path
  end

  test "visiting the account_root redirects to sign_in path" do
    visit account_root_url

    refute_equal current_path, account_root_path

    assert_equal current_path, new_account_session_path
  end

  test "filling in the sign up form redirects to account_root" do
    visit new_account_registration_url
    fill_in "Username", with: "random_username"

    fill_in "Email", with: "random@email.com"

    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"

    click_on "Sign up"

    assert_selector "input[type=submit][value='Shorten']"

    assert_equal current_path, account_root_path
  end

  test "filling in the sign up form with invalid credentials doesn't redirect to account_root" do
    visit new_account_registration_url
    fill_in "Username", with: "random_username"
    fill_in "Email", with: "randomemail.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"

    click_on "Sign up"

    refute_equal current_path, account_root_path
  end

  test "filling in the sign in form redirects to account_root" do
    account = create_account("random_username", "random@email.com", "password")
    visit new_account_session_url

    fill_in "Email", with: account.email
    fill_in "Password", with: "password"

    click_on "Log in"

    assert_selector "input[type=submit][value='Shorten']"

    assert_equal current_path, account_root_path
  end

  test "filling in the sign in form with invalid credentials doesn't redirect to account_root" do
    visit new_account_session_url

    fill_in "Email", with: "random@email.com"
    fill_in "Password", with: "password"

    click_on "Log in"

    refute_equal current_path, account_root_path

    assert_equal current_path, new_account_session_path
  end

  teardown do
    Capybara.default_max_wait_time = 2
  end

  private

  def click_email_link(mail = ActionMailer::Base.deliveries.last)
    body = mail.body.encoded
    url = body[/http[^"]+/]
    visit url
  end

  def create_account(username, email, password)
    Account.create(username: username, email: email, password: password)
  end
end
