


class Sale < ActiveRecord::Base
  extend Geocoder::Model::ActiveRecord
  

  belongs_to :user
  has_many :items

  validates :address, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  geocoded_by :address
  after_validation :geocode

  mount_uploader :image_path, ImageUploader



end