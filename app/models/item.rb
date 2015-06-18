class Item < ActiveRecord::Base
  belongs_to :sale
  validates :item_name, presence: true

end