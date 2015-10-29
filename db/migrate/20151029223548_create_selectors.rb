class CreateSelectors < ActiveRecord::Migration
  def change
    create_table :selectors do |t|

      t.timestamps null: false
      t.string :url_base, null: false
      t.string :selector, null: false
      
    end
  end
end
