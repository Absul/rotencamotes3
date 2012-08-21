class List < ActiveRecord::Base
  # relationships
  belongs_to  :user
  has_many    :items
  
  # validations
  validates_presence_of :title
  validates_presence_of :user

  record_activity_of :user, :actions => [:create, :update]

  #methods
  def to_param
    "#{id}-#{title.parameterize}"
  end

  def create_items(items)
    if items
      items.each_with_index do |item,index|
        self.items.create :listable_id => item.to_i, :listable_type => "Movie", :position => index+1
      end
    end
  end

  def movies
    Movie.find_all_by_id(self.items.of_movies.map(&:listable_id))
  end

end

# == Schema Information
#
# Table name: lists
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  description :text
#  user_id     :integer(4)
#  status      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

