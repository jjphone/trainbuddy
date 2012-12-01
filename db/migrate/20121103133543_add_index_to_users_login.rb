class AddIndexToUsersLogin < ActiveRecord::Migration
  def change
  	add_index :users, :login, unique: true
  	add_index :users, :phone, unique: true
  end
end
