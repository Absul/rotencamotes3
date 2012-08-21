# encoding: UTF-8
class User < ActiveRecord::Base

  has_attached_file :avatar, :styles => { :thumb => "100x100>", :banner => "150x222#", :medium => "300x300>", :thumb => "100x100>", :avatar => "64x64#" }, :storage => :s3,
                    :s3_credentials => { :access_key_id => "1B7JJ1RZXMZP7VQADY02" , :secret_access_key =>"8UvZq1RtsyE72t0vq2U1FaaZStGXm9fj87uFub2b" },
                    :path => "system/:attachment/:id/:style/:basename.:extension",
                    :bucket => lambda { |attachment| i = attachment.instance.id;  i = (i ? i % 4 : 0) ;"assets#{i}.votencamotes.com"}

  validates_presence_of   :email
  validates_presence_of   :last_name, :on => :update
  validates_uniqueness_of :email
  has_one   :profile
  has_many  :posts
  has_many  :categories
  has_many  :comments
  has_one   :blog
  has_many  :scores
  has_many  :lists, :order => "created_at DESC"
  has_many  :recomendations

  has_many :user_movies
  has_many :movies, :through => :user_movies
  has_many :created_movies, :class_name => "Movie", :foreign_key => "user_id"

  after_create  :setup_profile

  accepts_nested_attributes_for :profile

  # record_activity_of :user, :actions => [:create, :update]

  devise  :registerable, :database_authenticatable,:recoverable,:rememberable, :trackable, :validatable, :omniauthable
          #,:oauth2_authenticatable

  ROLES = {
    :admins     => 'admins',
    :community  => 'community',
    :experts    => 'experts'
  }

  scope :community, :conditions =>  { :member_of => ROLES[:community] }
  scope :experts,   :conditions =>  { :member_of => ROLES[:experts]   }
  scope :admins,   :conditions =>  { :member_of => ROLES[:admins]   }

  scope :members_of, lambda { |role| {:conditions => "member_of_mask & #{2**User.roles_list.index(role.to_s)} > 0"} }

  def self.community
    User.members_of(ROLES[:community])
  end
  
  def self.experts
    User.members_of(ROLES[:experts])    
  end
  
  def self.admins
    User.members_of(ROLES[:admins])
  end
  
  def self.roles_list
    ROLES.values.sort
  end
  

  # methods
  
  def seen_movies
    Movie.find(:all, :select => "distinct movies.*",:joins => :scores, :conditions => {:scores =>{:user_id => self.id }})
  end
  
  
  def member_of=(roles)
      roles = [*roles] unless roles.is_a? Array
        
      self.member_of_mask = (roles & User.roles_list).map { |r| 2**User.roles_list.index(r) }.sum
  end

  def member_of
    User.roles_list.reject { |r| ((self.member_of_mask || 0) & 2**User.roles_list.index(r)).zero? }
  end
    
  def full_name
    "#{first_name} #{last_name}"
  end

  alias :name :full_name

  def mark_as_community_member
    self.member_of = ROLES[:community]
    self.save
  end

  def mark_as_expert
    self.member_of = ROLES[:experts]
    self.save
  end

  def mark_as_admin
    self.member_of = ROLES[:admins]
  end

  def community_member?
    self.member_of.include? ROLES[:community]
  end

  def expert?
    self.member_of.include? ROLES[:experts]
  end

  def admin?
    self.member_of.include? ROLES[:admins]
  end
  
  def scores_as
    if expert?
      ROLES[:experts]
    else
      ROLES[:community]
    end
  end

  def rate_movie(movie_id, value)
    Score.rate(self, movie_id, value)
  end

  def allowed_to_post?
    self.blog.present? && expert?
  end

  def build_post
    if allowed_to_post?
      post = self.blog.posts.build
      post.user = self
      return post
    end
  end

  def allowed_to_score?
    true
  end

  def build_score
    if allowed_to_score?
      score = self.scores.build
      score.user = self
      return score
    end
  end
  
  def not_rated?(movie)
    Score.from_user(self.id).from_movie(movie.id).empty?
  end

  def allowed_to_comment?
    true
  end

  def build_comment_on(post_id)
    if allowed_to_comment?
      comment = self.comments.build
      comment.post = Post.find(post_id)
      return comment
    end
  end

  def has_comments?
    not self.comments.empty?
  end

  def has_published_posts?
    not self.posts.published.empty?
  end

  def setup_profile
    self.create_profile
  end
  
  def to_param
     "#{id}-#{self.try(:full_name).try(:parameterize)}"
   end
  
end










# == Schema Information
#
# Table name: users
#
#  id                   :integer(4)      not null, primary key
#  first_name           :string(255)
#  last_name            :string(255)
#  email                :string(255)     default(""), not null
#  password             :string(255)
#  born_at              :date
#  created_at           :datetime
#  updated_at           :datetime
#  encrypted_password   :string(128)     default(""), not null
#  password_salt        :string(255)     default(""), not null
#  confirmation_token   :string(255)
#  confirmed_at         :datetime
#  confirmation_sent_at :datetime
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer(4)      default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  avatar_file_name     :string(255)
#  avatar_content_type  :string(255)
#  avatar_file_size     :integer(4)
#  avatar_updated_at    :datetime
#  website              :string(255)
#  member_of_mask       :integer(4)      default(2)
#  oauth2_uid           :integer(8)
#  oauth2_token         :string(149)
#  bio                  :text
#  one_line_bio         :string(255)
#  url                  :string(255)
#

