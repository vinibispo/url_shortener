class AddClicksToUrls < ActiveRecord::Migration[8.0]
  def change
    add_column :urls, :clicks, :integer, null: false, default: 0
  end
end
