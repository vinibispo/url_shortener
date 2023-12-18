class AddClicksToUrls < ActiveRecord::Migration[7.1]
  def change
    add_column :urls, :clicks, :integer, null: false, default: 0
  end
end
