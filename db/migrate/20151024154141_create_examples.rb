class CreateExamples < ActiveRecord::Migration
  def change
    create_table :examples do |t|
      t.string :name
      t.string :integer
      t.string :desc
      t.string :string

      t.timestamps null: false
    end
  end
end
