# encoding: UTF-8
require 'nokogiri'
require 'action_view'

class Post < ActiveRecord::Base
  # relationships
  belongs_to              :blog, :counter_cache => true
  belongs_to              :user
  belongs_to              :movie
  belongs_to              :play
  has_many                :post_categories
  has_many                :categories, :through  => :post_categories
  has_many                :comments,   :order    => 'created_at DESC'

  # validations
  validates_presence_of   :title
  validates_presence_of   :content
  validates_presence_of   :user_id
  validates_uniqueness_of :title
  
  record_activity_of :user, :actions => [:create, :update], :if => Proc.new {|post| post.new_record? || %w(content).any? {|w| post.changed.include?(w)}}

  #accesible attributes
  attr_accessible :title, :content, :user_id, :permalink,
                  :blog_id, :tag_list, :drafted_at, :published_at,
                  :reviewed_at, :movie_id, :rating, :category_ids,
                  :cached_tag_list, :comments_count, :visits_count, :headlines, :status

  # permalink config
  # has_permalink :title, :update => true,
  #               :if => Proc.new { |post| post.nil? or post.permalink.blank? }

  before_save :update_permalink

  def update_permalink
    self.permalink ||= self.title.parameterize
  end

  # valid post types
  STATUSES = {
                :drafted    => 'drafted',
                :reviewed   => 'reviewed',
                :published  => 'published'
  }

  #named scopes
  scope :sitemap, :select => 'id, permalink, title, created_at, updated_at',
              :limit => 29999 # +1 for About page to make 50,000
  scope :drafted,
              :conditions => { :status => STATUSES[:drafted] },
              :order => 'drafted_at DESC'
  scope :published,
              :conditions => { :status => STATUSES[:published] },
              :order => 'published_at DESC'

  scope :reviewed,
              :conditions => { :status => STATUSES[:reviewed] },
              :order => 'reviewed_at DESC'
  scope :active,
              :conditions => { :blogs => {:active => true}},
              :joins => :blog
  scope :last_published,
              lambda {|limit| limit = 20 if limit.nil?
                      {:order =>  'created_at DESC',
                       :conditions => ["status like ? and published_at <= ?",STATUSES[:published],Time.zone.now],
                       :limit => limit
                     }
               }
  scope :most_commented,
              lambda {|limit| limit = 20 if limit.nil?
                      {:order =>  'comments_count DESC',
                       :conditions => { :status => STATUSES[:published] },
                       :limit => limit
                     }
               }
  scope :most_visited,
              lambda {|limit| limit = 20 if limit.nil?
                      {:order =>  'visits_count DESC',
                       :conditions => { :status => STATUSES[:published] },
                       :limit => limit
                     }
               }
  scope :next_from,
              lambda { |limit,offset|
                      { :order => 'published_at DESC',
                        :limit => limit,
                        :offset => offset
                      }
              }
  scope :from_category,
              lambda { |category_id|
                      { :order => 'published_at DESC',
                        :conditions =>{:category_id => category_id}
                      }
              }

  scope :from_named_category,
              lambda { |category_permalink|
                      { :conditions =>{:post_categories => {:categories => {:name => category_permalink.titleize}}},
                        :joins => {:post_categories=>:category}
                      }

              }

  scope :from_blog_with_category,
              lambda { |category_permalink|
                      { :conditions =>{:categories => {:permalink => category_permalink}},
                        :joins => {:blog=>:category}
                      }
              }

  scope :from_blog_with_named_category,
              lambda { |category_permalink|
                      { :conditions => {:blog => {:categories=>{:permalink => category_permalink}}},
                        :joins => {:blog=>:category}
                      }
              }
  scope :tagged_with,
              lambda { |tags|
                Post.find_options_for_find_tagged_with(tags, :match_all => true)
              }

  # summary size
  EXCERPT_SIZE = 40

  #active acts_as_taggable for Posts
  acts_as_taggable

  #define included attributes for thinking-sphinx indexing
  # define_index do
  #   indexes title, :sortable => true
  #   indexes content
  #   indexes permalink, :sortable => true
  #   indexes cached_tag_list
  #   has user_id, created_at, updated_at, blog_id
  #   set_property :delta => true
  # end

  # Status update
  def setup_to_mark_as_drafted
    self.status = STATUSES[:drafted]
    self.drafted_at = Time.zone.now
    self.permalink ||= self.title.parameterize
  end

  def mark_as_drafted
    self.setup_to_mark_as_drafted
    self.save
  end

  def setup_to_mark_as_reviewed
    self.status = STATUSES[:reviewed]
    self.reviewed_at = Time.zone.now
  end

  def mark_as_reviewed
    self.setup_to_mark_as_reviewed
    self.save
  end

  def setup_to_mark_as_published
    self.setup_to_mark_as_drafted
    self.status = STATUSES[:published]
    self.published_at ||= Time.zone.now
    self.permalink ||= self.title.parameterize
  end

  def mark_as_published
    self.setup_to_mark_as_published
    self.save
  end

  # Status get
  def drafted?
    self.status == STATUSES[:drafted]
  end

  def reviewed?
    self.status == STATUSES[:reviewed]
  end

  def published?
    self.status == STATUSES[:published]
  end

  # Categories
  def category_names
    self.categories.empty? ? '' : self.categories.map(&:name).join(',')
  end

  def movie_title
    self.movie.nil? ? '' : self.movie.title
  end
  
  def title_with_score
    if self.rating && self.rating > 1
      "#{self.title} (#{ActionView::Base.new.number_to_percentage(self.rating, :precision => 0)})"
    else
      self.title
    end
  end

  def to_param
    if self.movie
      "#{id}-#{self.movie.title.parameterize}-#{title.parameterize}"
    else
      "#{id}-#{self.title.parameterize}"
    end
  end

  def post_images
    @post_images ||= doc.css('img').map{|i| i.attributes["src"].content}
  end

  def post_embeds
    @post_embeds ||= doc.css('object').map(&:to_html)
  end

  private

  def doc
    @doc ||= Nokogiri::HTML(self.content)
  end

end






# == Schema Information
#
# Table name: posts
#
#  id              :integer(4)      not null, primary key
#  title           :string(255)
#  content         :text
#  user_id         :integer(4)
#  permalink       :string(255)
#  blog_id         :integer(4)
#  drafted_at      :datetime
#  published_at    :datetime
#  reviewed_at     :datetime
#  cached_tag_list :string(255)
#  comments_count  :integer(4)
#  visits_count    :integer(4)
#  rating          :decimal(4, 2)   default(0.0)
#  delta           :boolean(1)      default(TRUE)
#  status          :string(255)     default("drafted")
#  created_at      :datetime
#  updated_at      :datetime
#  movie_id        :integer(4)
#  headlines       :text
#

