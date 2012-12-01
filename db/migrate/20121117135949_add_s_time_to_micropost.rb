class AddSTimeToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :s_time, :datetime
    add_column :microposts, :e_time, :datetime
  end
end
