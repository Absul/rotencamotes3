class Play < ActiveRecord::Base
  has_many :schedules
  has_many :posts
end
