class AddUsernameToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :username, :string, null: false, default: ''
  end
end
