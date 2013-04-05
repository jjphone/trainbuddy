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

execute "insert into level_settings(level, max_score, multi,  admin, password, friends,  message,info, login,    post,search_mode,nearby,  plans_value,notify_users,invitations) values 
(1,100,0, 0,1,1, 1,1,1, 2,2,1, 3,2,1),
(2,200,1,0,2,2,2,2,1,2,1,0,2,1,10),
(3,300,2,0,2,2,2,2,1,2,1,0,3,1,10),
(4,400,1,0,2,2,2,2,1,2,2,1,3,1,10),
(5,500,2,0,2,2,2,2,1,2,2,1,4,2,10),
(6,600,1,0,2,2,2,2,1,2,2,2,4,2,10),
(7,700,2,0,2,2,2,2,1,2,2,2,5,2,10),
(8,800,1,0,2,2,2,2,1,2,2,3,5,2,10),
(9,900,2,0,2,2,2,2,1,2,2,3,6,3,10),
(10,1000,1,0,2,2,2,2,1,2,2,4,6,3,10),
(11,1100,2,0,2,2,2,2,1,2,2,4,7,3,10),
(12,1200,0,0,2,2,2,2,1,2,2,5,7,3,10),
(99,9999,0,2,2,2,2,2,2,2,2,9,10,10,99)
;"
  end
  
  def down
    drop_table :level_settings
  end



end
