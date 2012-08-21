# encoding: UTF-8
class UserMovie < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :movie
  
end

# == Schema Information
#
# Table name: user_movies
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  movie_id   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

