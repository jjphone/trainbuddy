class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles, primary_key: 'user_id' do |t|
      t.integer :user_id,  null: false
      t.integer :search_mode, default: 0
      t.integer :level, default: 1
      t.integer :score, default: 0

      t.timestamps
    end


  end
end
