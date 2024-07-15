class CreateSelections < ActiveRecord::Migration[7.1]
  def change
    create_table :selections do |t|
      t.references :order, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
