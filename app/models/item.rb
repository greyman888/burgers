class Item < ApplicationRecord
  has_many :selections,     dependent: :destroy
  has_many :orders,         through: :selections
end
