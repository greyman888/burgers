class Selection < ApplicationRecord
  belongs_to :order
  belongs_to :item

  has_many :modifications,  dependent: :destroy
  has_many :items,          through: :modifications
end
