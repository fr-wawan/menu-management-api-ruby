class CreateMenuItems < ActiveRecord::Migration[8.1]
  def change
    create_table :menu_items do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.string :category
      t.boolean :is_available
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
