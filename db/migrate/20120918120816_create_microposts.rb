class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.integer 	:user_id
      t.string 		:content
      t.string		:opt_link
      t.integer 	:message_id
      t.timestamps	:s_time
      t.timestamps	:e_time
      t.timestamps	:expire_time


      t.timestamps
    end
    add_index 		:microposts, [:user_id, :created_at]
  end
end
