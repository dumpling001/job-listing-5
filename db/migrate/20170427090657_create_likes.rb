class CreateLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :likes do |t|
      t.integer :job_id
      t.integer :user_id
      t.boolean :is_liked, default: false

      t.timestamps
    end
  end
end
