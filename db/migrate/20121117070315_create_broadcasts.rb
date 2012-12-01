class CreateBroadcasts < ActiveRecord::Migration
  def change
    create_table :broadcasts do |t|
      t.integer :user_id
      t.integer :status
      t.integer :source
      t.integer :ref_msg
      t.string  :bc_content

      t.timestamps
    end
  end
end
