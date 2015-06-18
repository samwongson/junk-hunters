


class Sale < ActiveRecord::Base
  

  belongs_to :user
  has_many :items

  validates :address, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  mount_uploader :image_path, ImageUploader



end