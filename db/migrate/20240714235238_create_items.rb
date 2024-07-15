class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :name
      t.integer :price
      t.string :size
      t.string :category

      t.timestamps
    end
  end
end
