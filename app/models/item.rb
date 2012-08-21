class Item < ActiveRecord::Base

  # relationships
  belongs_to :list
  
  # validations
  validates_presence_of :list
  validates_presence_of :position
  validates_presence_of :listable_type
  
  # enable list item behavior
  acts_as_list  :scope => :list
  
  # named scopes
  named_scope :from_list,
    lambda { |list_id| {
        :conditions => {:list_id => list_id},
        :order => 'position'
      }
    }
  
  named_scope :of_movies, :conditions => {:listable_type => "Movie"}

  named_scope :from_movie,
    lambda { |movie_id|{
      :conditions => {:listable_id => movie_id, :listable_type => "Movie"}
      }
    }
  def movie
    Movie.find(self.listable_id)
  end

end


# == Schema Information
#
# Table name: items
#
#  id            :integer(4)      not null, primary key
#  list_id       :integer(4)
#  listable_id   :integer(4)
#  listable_type :string(255)
#  description   :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  position      :integer(4)
#

