class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|

      t.timestamps null: false

      t.references :lightnovel, null: false, index: true, foreign_key: true
      t.string :chapter_name, null: false
      t.integer :chapter_number, null: false
      t.integer :volume, null: false
      t.integer :volume_chapter_number, null: false
      t.string  :raws_url, null: false
      t.string  :translated_url, default: 0

    end
  end
end