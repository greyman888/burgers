class AddMealIdToSelection < ActiveRecord::Migration[7.1]
  def change
    add_column :selections, :meal_id, :integer
    add_foreign_key :selections, :selections, column: :meal_id
    add_index :selections, :meal_id
  end
end
