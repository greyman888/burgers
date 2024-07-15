class CreateModifications < ActiveRecord::Migration[7.1]
  def change
    create_table :modifications do |t|
      t.references :selection, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
