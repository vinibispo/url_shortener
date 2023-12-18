class AddAccountIdToUrls < ActiveRecord::Migration[7.1]
  def change
    add_column :urls, :account_id, :integer

    add_index :urls, :account_id
  end
end
