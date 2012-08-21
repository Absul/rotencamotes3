# encoding: UTF-8
class Recomendation < ActiveRecord::Base
 belongs_to :movie
 belongs_to :user
  
  validates_presence_of :movie_id
end
