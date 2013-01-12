class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.string :loc
      t.string :time
      t.string :subj
      t.string :mate

      t.timestamps
    end
    add_index :plans, [:user_id,:name], unique: true
  end
end
