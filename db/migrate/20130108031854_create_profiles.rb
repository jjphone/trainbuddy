class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles, primary_key: 'user_id' do |t|
      t.integer :user_id,  null: false
      t.integer :search_mode, default: 0, null: false, limit:2
      t.integer :level, default: 2, null: false, limit: 2
      t.integer :score, default: 0, null: false
      t.integer :notify_users, default: 1, null: false, limit: 2
      t.integer :invitations, default: 10, null: false, limit: 2

      t.timestamps
    end


  end
end
