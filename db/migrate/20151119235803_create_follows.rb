class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|

      t.timestamps null: false
      t.belongs_to :user, index: true
      t.belongs_to :lightnovel, index: true
    end
    add_index(:follows, [:user_id, :lightnovel_id], unique: true)
  end
end
