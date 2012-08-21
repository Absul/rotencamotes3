class TinyVideo < ActiveRecord::Base
  
  has_attached_file :original, :storage => :s3,
                    :s3_credentials => { :access_key_id => "1B7JJ1RZXMZP7VQADY02" , :secret_access_key =>"8UvZq1RtsyE72t0vq2U1FaaZStGXm9fj87uFub2b" },
                    :path => "system/:attachment/:id/:style/:basename.:extension",
                    :bucket => lambda { |attachment| i = attachment.instance.id;i = (i ? i % 4 : 0);"assets#{i}.votencamotes.com"}
  #, :path => "videos/:original/:id.:extension",

end

# == Schema Information
#
# Table name: tiny_videos
#
#  id                    :integer(4)      not null, primary key
#  original_file_name    :string(255)
#  original_file_size    :string(255)
#  original_content_type :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

