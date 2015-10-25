class CreateLightnovels < ActiveRecord::Migration
  def change
    create_table :lightnovels do |t|

      t.timestamps null: false

      t.string	:name, null: false
      t.string	:description, null: false
      t.integer	:total_number_of_chapters, null: false
      t.string	:raws_url, null: false
      t.boolean	:is_translated, default: false
      t.integer	:translated_chapters, default: 0
      t.string	:translated_url, default: 0

    end
  end
end
