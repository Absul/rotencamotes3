# encoding: UTF-8
class Widget < ActiveRecord::Base

  # valid post types
  STATUSES = {
    :unactive   => 'unactive',
    :active  => 'active'
  }

  PLACE = {
    :left   => 'left',
    :right  => 'right'
  }



  validates_presence_of :title
  validates_presence_of :content
  
  


end


# == Schema Information
#
# Table name: widgets
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  content    :text
#  status     :string(255)     default("unactive")
#  position   :integer(4)      default(1)
#  place      :string(255)     default("left")
#  created_at :datetime
#  updated_at :datetime
#

