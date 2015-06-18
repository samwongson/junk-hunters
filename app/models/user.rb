class User < ActiveRecord::Base
  has_many :sales

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true

end
