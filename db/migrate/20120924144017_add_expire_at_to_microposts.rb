class AddExpireAtToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :expire_at, :datetime
  end
end
