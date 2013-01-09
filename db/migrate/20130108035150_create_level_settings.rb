class CreateLevelSettings < ActiveRecord::Migration
  def change
    create_table :level_settings, primary_key: 'level' do |t|
      t.integer :level, null: false
      t.integer :max_score
      t.integer :step_value
      t.integer :admin, default: 0, limit: 1
      t.integer :password, default: 7, limit: 1
      t.integer :friends, default: 7,  limit: 1
      t.integer :info, default: 7, limit: 1
      t.integer :login, default: 7, limit: 1
      t.integer :post, default: 7, limit: 1
      t.integer :search_mode, default: 7, limit: 1
      t.integer :nearby, default: 7, limit: 1
      t.integer :plans_value, default: 1, limit: 2


      t.timestamps
    end

execute "insert into level_settings(level, max_score, step_value, admin, password, friends,  info, login, post,  search_mode,nearby,plans_value) values 
(1,100,0,0,1,1,1,1,2,2,1,3),
(2,200,10,0,2,2,2,1,2,1,0,2),
(3,300,20,0,2,2,2,1,2,1,0,3),
(4,400,10,0,2,2,2,1,2,2,1,3),
(5,500,20,0,2,2,2,1,2,2,1,4),
(6,600,10,0,2,2,2,1,2,2,2,4),
(7,700,20,0,2,2,2,1,2,2,2,5),
(8,800,10,0,2,2,2,1,2,2,3,5),
(9,900,20,0,2,2,2,1,2,2,3,6),
(10,1000,10,0,2,2,2,1,2,2,4,6),
(11,1100,20,0,2,2,2,1,2,2,4,7),
(12,1200,0,0,2,2,2,1,2,2,5,7),
(99,9999,0,2,2,2,2,2,2,2,9,10)

;"


  end
end
