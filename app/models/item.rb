class Item < ApplicationRecord
  has_many :selections,     dependent: :destroy
  has_many :orders,         through: :selections

  has_many :modifications,  dependent: :destroy
  has_many :selections,     through: :modifications
end
