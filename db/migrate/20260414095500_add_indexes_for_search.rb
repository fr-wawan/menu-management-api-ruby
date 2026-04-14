class AddIndexesForSearch < ActiveRecord::Migration[8.1]
  def change
    add_index :restaurants, :name
    add_index :menu_items, :name
  end
end
