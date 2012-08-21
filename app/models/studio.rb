class Studio < ActiveRecord::Base
  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :storage => :s3,
                    :s3_credentials => { :access_key_id => "1B7JJ1RZXMZP7VQADY02" , :secret_access_key =>"8UvZq1RtsyE72t0vq2U1FaaZStGXm9fj87uFub2b" },
                    :path => "system/:attachment/:id/:style/:basename.:extension",
                    :bucket => lambda { |attachment| i = attachment.instance.id % 4;"assets#{i}.votencamotes.com"}
  has_many :movies
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
  
end



# == Schema Information
#
# Table name: studios
#
#  id                :integer(4)      not null, primary key
#  name              :string(255)
#  address           :string(255)
#  bio               :text
#  created_at        :datetime
#  updated_at        :datetime
#  logo_file_name    :string(255)
#  logo_content_type :string(255)
#  logo_file_size    :integer(4)
#  logo_updated_at   :datetime
#

