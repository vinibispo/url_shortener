class Account::BaseController < ApplicationController
  before_action :authenticate_account!
end
