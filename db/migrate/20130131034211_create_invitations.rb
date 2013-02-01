class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :sender_id
      t.string :recipient_email
      t.string :token, null: false, unique: true
      t.datetime :sent_at
      t.integer :multiple, default: 1, limit: 2

      t.timestamps
    end
  end
end
