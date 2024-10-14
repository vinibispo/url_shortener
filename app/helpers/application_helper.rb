module ApplicationHelper
  include Pagy::Frontend

  def show_form_buttons?
    return false if controller_name == "sessions" || controller_name == "registrations"

    return false if account_signed_in?

    true
  end

  def show_logout_button?
    return false if controller_name == "sessions" || controller_name == "registrations"

    return true if account_signed_in?

    false
  end
end
