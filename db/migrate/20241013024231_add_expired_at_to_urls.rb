class AddExpiredAtToUrls < ActiveRecord::Migration[8.0]
  def change
    add_column :urls, :expired_at, :datetime, default: nil
  end
end
