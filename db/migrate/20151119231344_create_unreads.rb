class CreateUnreads < ActiveRecord::Migration
  def change
    create_table :unreads do |t|

      t.timestamps null: false
      t.belongs_to :user, index: true
      t.belongs_to :chapter, index: true
      t.string :lightnovel_name, index: true
    end
    add_index(:unreads, [:user_id, :chapter_id], unique: true)
  end
end
