class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.integer :status
      t.integer :parent_id
      t.string :content

      t.timestamps
    end
  end
end
