class AddMissingItemsToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :missing, :string
  end
end
