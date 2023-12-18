require 'application_system_test_case'
class Account::DashboardTest < ApplicationSystemTestCase
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

  teardown do
    Capybara.default_max_wait_time = 2
  end
end
