class CreateLightnovels < ActiveRecord::Migration
  def change
    create_table :lightnovels do |t|

      t.timestamps null: false

      t.string	:name, null: false
      t.string	:description, null: false
      t.string	:home_url, null: false
      t.boolean	:is_translated, default: false
      t.string	:raws_url, default: nil
      t.integer :number_of_chapters, default: 0
      t.datetime :last_modified, default: Time.now
    end
  end
end