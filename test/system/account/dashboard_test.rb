require 'application_system_test_case'
class Account::DashboardTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    Capybara.default_max_wait_time = 10
  end

  test 'private links aren\'nt public' do
    account = Account.create(username: 'test', password: '123456', email: 'test@email.com')
    visit root_path
    click_on 'Log In'

    fill_in 'Email', with: account.email

    fill_in 'Password', with: '123456'

    click_on 'Log in'

    # Now we are logged in

    fill_in 'Enter your link', with: 'https://www.google.com'

    fill_in 'Customize your link', with: 'google'

    click_on 'Shorten'

    # Now we have a link

    assert_text 'google'

    click_on 'Log Out'

    # Now we are logged out

    refute_text 'google'
  end

  test 'invalid links aren\'nt created' do
    account = Account.create(username: 'random', email: 'random@email.com', password: '123456')

    sign_in account

    visit account_root_path

    fill_in 'Enter your link', with: ''

    click_on 'Shorten'

    assert_text "can't be blank"

    fill_in 'Enter your link', with: 'foobar'

    click_on 'Shorten'

    assert_text 'Original url is invalid'
  end


  test 'creates a link when using one of the blocklist' do
    account = Account.create(username: 'test', password: '123456', email: 'test@email.com')

    sign_in account

    visit account_root_path

    link = File.read(Rails.root.join('lib', 'files', 'blocklist.txt')).split("\n").sample

    fill_in 'Enter your link', with: "https://#{link}"

    click_on 'Shorten'

    assert_text "https://#{link[0..5]}"
  end

  test 'edits a link' do
    account = Account.create(username: 'test', password: '123456', email: 'test@email.com')

    sign_in account

    visit account_root_path

    fill_in 'Enter your link', with: 'https://www.google.com'

    fill_in 'Customize your link', with: 'google'

    click_on 'Shorten'

    assert_text 'google'

    click_on '✏️'

    fill_in 'Customize your link', with: 'google2'

    click_on 'Shorten'

    assert_text 'google2'
  end

  test 'deletes a link' do
    account = Account.create(username: 'test', password: '123456', email: 'test@email.com')

    sign_in account

    visit account_root_path

    fill_in 'Enter your link', with: 'https://www.google.com'

    fill_in 'Customize your link', with: 'google'

    click_on 'Shorten'

    assert_text 'google'

    accept_confirm do
      click_on '🗑️'
    end

    refute_text 'google'

    assert_text 'Url removed'
  end

  teardown do
    Capybara.default_max_wait_time = 2
  end
end
