class Order < ApplicationRecord
  has_many :selections,     dependent: :destroy
  has_many :items,          through: :selections
end
