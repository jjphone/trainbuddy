class CreateLevelSettings < ActiveRecord::Migration
  def up
    create_table :level_settings, primary_key: 'level' do |t|

      t.integer :level, null: false
      t.integer :max_score
      t.integer :multi, default: 0

      t.integer :admin, default: 0, limit: 1
      t.integer :password, default: 7, limit: 1
      t.integer :friends, default: 7,  limit: 1

      t.integer :message, default: 0, limit: 1
      t.integer :info, default: 7, limit: 1
      t.integer :login, default: 7, limit: 1

      t.integer :post, default: 7, limit: 1
      t.integer :search_mode, default: 7, limit: 1
      t.integer :nearby, default: 7, limit: 1

      t.integer :plans_value, default: 1, limit: 2
      t.integer :notify_users, default: 1, limit: 2
      t.integer :invitations, default: 10, limit: 2


      t.timestamps
    end
  end
  
  def down
    drop_table :level_settings
  end



end
