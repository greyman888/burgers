class Modification < ApplicationRecord
  belongs_to :selection
  belongs_to :item
end
