class Item < ActiveRecord::Base
  belongs_to :sale
  validates :name, presence: true


end