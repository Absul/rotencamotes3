# encoding: UTF-8
class MovieCharacter < ActiveRecord::Base
  # relationships
  belongs_to              :movie
  belongs_to              :person

  # validations
  #validates_presence_of   :character_name
  validates_presence_of   :person
  validates_presence_of   :movie
  # validates_uniqueness_of :character_name, :scope => :movie_id

  # named scopes
  scope :from_movie,
              lambda  { |movie_id|  {
                  :conditions =>  { :movie_id  =>  movie_id },
                  :order      =>  'character_name DESC'
                }
              }

  scope :from_actor,
              lambda  { |person_id|  {
                  :conditions =>  { :person_id  =>  person_id },
                  :order      =>  'character_name DESC'
                }
              }
  def cast_member
    (self.character_name.nil? or self.character_name == "&nbsp;") ? self.try(:person).try(:full_name) : self.try(:person).try(:full_name) << ' (' << self.character_name << ')'
  end

end

# == Schema Information
#
# Table name: movie_characters
#
#  id             :integer(4)      not null, primary key
#  movie_id       :integer(4)
#  person_id      :integer(4)
#  character_name :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

