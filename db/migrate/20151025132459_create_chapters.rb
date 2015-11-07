class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|

      t.timestamps null: false

      t.references :lightnovel, null: false, foreign_key: true
      t.string :chapter_name, null: false
      t.integer :chapter_number, null: false
      t.string  :chapter_url, null: false
      t.string  :raws_url, default: nil

    end
  end
end