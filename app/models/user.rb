class User < ActiveRecord::Base
  has_many :sales

  validates :username, presence: true
  validates :password, presence: true

end
