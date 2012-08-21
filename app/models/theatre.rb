# encoding: UTF-8
class Theatre < ActiveRecord::Base
  belongs_to            :movie_chain
  has_many              :schedules
  has_many              :scores
  validates_presence_of :name
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
    
  def self.cities
    Theatre.all.map(&:city).compact.uniq.map{|c| [c,c.downcase] }
  end  
    
end









# == Schema Information
#
# Table name: theatres
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  address        :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  movie_chain_id :integer(4)
#  phone          :string(255)
#  lat            :string(255)
#  long           :string(255)
#  city           :string(255)
#  state          :string(255)
#

