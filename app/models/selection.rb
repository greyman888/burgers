class Selection < ApplicationRecord
  belongs_to :order
  belongs_to :item

  has_many :modifications,  dependent: :destroy
  has_many :items,          through: :modifications

  belongs_to :parent_meal, class_name: 'Selection', optional: true, foreign_key: 'meal_id'
  has_many :meal_selections, class_name: 'Selection', foreign_key: 'meal_id', dependent: :destroy
end
