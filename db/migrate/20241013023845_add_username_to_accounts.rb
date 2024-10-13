class AddUsernameToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :username, :string, null: false, default: ''
  end
end
