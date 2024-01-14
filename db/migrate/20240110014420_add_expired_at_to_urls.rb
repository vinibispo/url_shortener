class AddExpiredAtToUrls < ActiveRecord::Migration[7.1]
  def change
    add_column :urls, :expired_at, :datetime, default: nil
  end
end
