class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :user_id
      t.integer :status
      t.integer :message_id
      t.string	:msg_comment

      t.string	:train_no
      t.integer	:line
      t.integer	:dir
      t.integer	:s_stop
      t.integer	:e_stop
      t.string	:final_stop

      t.datetime	:s_time
      t.datetime	:e_time
      t.datetime	:expiry

      t.timestamps
    end
    add_index	:activities,	:user_id
    add_index	:activities,	:expiry
  end
end
