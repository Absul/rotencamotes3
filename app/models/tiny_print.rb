# encoding: UTF-8
class TinyPrint < ActiveRecord::Base
  
  has_attached_file :image,
    :convert_options => { :quality =>  4 },
    :styles => { :small_thumb => [ "50x50", :jpg ],
	               :medium_thumb => [ "100x100", :jpg ],
                 :large_thumb => [ "370x370", :jpg ],
	               :detail_preview => [ "450x338", :jpg ] },
    #:path => "/prints/:id/:style.:extension",
    :default_url => "/images/missing/prints/:style.png", :storage => :s3,
                      :s3_credentials => { :access_key_id => "1B7JJ1RZXMZP7VQADY02" , :secret_access_key =>"8UvZq1RtsyE72t0vq2U1FaaZStGXm9fj87uFub2b" },
                      :path => "system/:attachment/:id/:style/:basename.:extension",
                      :bucket => lambda { |attachment| i = attachment.instance.id;  i = (i ? i % 4 : 0) ;"assets#{i}.votencamotes.com"}

end

# == Schema Information
#
# Table name: tiny_prints
#
#  id                 :integer(4)      not null, primary key
#  image_file_name    :string(255)
#  image_file_size    :string(255)
#  image_content_type :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

