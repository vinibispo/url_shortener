class AddAccountIdToUrls < ActiveRecord::Migration[8.0]
  def change
    add_column :urls, :account_id, :integer

    add_index :urls, :account_id
  end
end
