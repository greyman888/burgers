class AddJsonToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :response, :text
  end
end
