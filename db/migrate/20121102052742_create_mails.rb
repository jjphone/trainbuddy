class CreateMails < ActiveRecord::Migration
  def change
    create_table :mails do |t|
      t.integer :owner
      t.integer :sender
      t.string 	:subj
      t.string 	:body
      t.string 	:option
      t.integer :status
      t.integer :parent_id
      t.string 	:to_users



      t.timestamps
    end
  end
end
