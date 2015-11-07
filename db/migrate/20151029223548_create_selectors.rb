class CreateSelectors < ActiveRecord::Migration
  def change
    create_table :selectors do |t|

      t.timestamps null: false
      t.string :url_base, null: false
      t.string :selector, null: false
      t.string :name, null: false
      
    end
    
    add_index :selectors, :url_base,                unique: true
  end
end
