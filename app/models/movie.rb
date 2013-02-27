#encoding: UTF-8
require 'nokogiri'

class Movie < ActiveRecord::Base

 # include ::DB_time


  has_attached_file :banner, :styles => { :medium => "300x300>", :thumb => "100x100>", :banner => "150x222#", :scheduled => "65x97#" }, :storage => :s3,
                    :s3_credentials => { :access_key_id => "1B7JJ1RZXMZP7VQADY02" , :secret_access_key =>"8UvZq1RtsyE72t0vq2U1FaaZStGXm9fj87uFub2b" },
                    :path => "system/:attachment/:id/:style/:basename.:extension",
                    :bucket => lambda { |attachment| i = attachment.instance.id;  i = (i ? i % 4 : 0) ;"assets#{i}.votencamotes.com"}


  # relationships
  belongs_to :studio
  has_many :movie_genres
  has_many :genres, :through => :movie_genres
  has_many :movie_directors
  has_many :directors, :through => :movie_directors
  has_many :movie_writers
  has_many :writers, :through => :movie_writers
  has_many :movie_characters
  has_many :characters, :through => :movie_characters, :source => :person
  has_many :fans, :class_name => "Profile", :foreign_key => "favorite_movie_id"
  has_many :awards
  has_many :assets
  has_many :scores
  has_many :schedules
  has_many :theatres, :through => :schedules
  has_many :posts
  has_many :comments
  has_many :user_movies
  has_many :movies, :through => :user_movies
  belongs_to :user
  has_many :items, :as => :listable
  has_many :recomendations


  MPAA_RATES = {
    :NR     => 'NR- This Film is Not Yet Rated',
    :G      => 'Apta para todos',
    :PG     => 'PG- Parental Guidance Suggested',
    :"PG-13"=> 'Mayores de 14 años',
    :R      => 'R- Restricted',
    :"NC-17"=> 'NC-17- No One 17 and Under Admitted'
  }

  LANGUAGES = {
    :sp =>  'Español',
    :en =>  'Inglés',
    :fr =>  'Francés',
    :de =>  'Alemán',
    :ch =>  'Chino',
    :jp =>  'Japonés',
    :pr =>  'Portugués'
  }
  
  record_activity_of :user, :actions => [:create, :update], :if => Proc.new {|movie| movie.new_record? || %w(title summary synopsis banner_file_name plain_cast plain_directors plain_writers trailers).any? {|w| movie.changed.include?(w)}}
  
  # validations
  validates_presence_of   :title
  # validates_uniqueness_of :released_at, :scope => :title, :case_sensitive => false

  #activate acts_as_taggable for Movie
  acts_as_taggable
  
  #named scopes
  scope :sitemap, :select => 'id, title, released_at, created_at, updated_at', :order => "updated_at DESC", :limit => 1999 # +1 for About page to make 50,000

  scope :from_named_genre,
              lambda{|genre_name|
                { :conditions => {:movie_genres=>{:genres=>{:name => genre_name}}},
                  :joins      => {:movie_genres=>:genre},
                  :order      => 'released_at DESC'
                }
              }

  scope :from_director,
              lambda {|director_id|
                { :conditions => {:movie_directors=>{:director_id => director_id}},
                  :joins      => {:movie_directors=>:director}
                }
              }

  scope :from_writer,
              lambda {|writer_id|
                { :conditions => {:movie_writers=>{:writer_id => writer_id}},
                  :joins      => {:movie_writers=>:writer}
                }
              }

  scope :from_actor,
              lambda {|actor_id|
                { :conditions => {:movie_characters=>{:actor_id => actor_id}},
                  :joins      => {:movie_characters=>:actor}
                }
              }

  scope :from_country,
              lambda { |country_id|
                { :conditions => {:country_id => country_id}
                }
              }

  scope :from_studio,
              lambda { |studio_id|
                { :conditions => {:studio_id => studio_id}
                }
              }

  scope :on_theatres,
              :select     => 'distinct movies.*',
              :conditions =>  DB_time.new.time_diff('schedules.created_at', '(select schedules.created_at from schedules order by created_at desc limit 1)') + "= 0",
              :joins      => :schedules,
              :order => "schedules.id DESC"


  scope :recommended,
              lambda {|limit|
                limit ||= 5
                { :limit=>limit,
                  :order=>"final_score DESC"
                }
              }

  scope :tagged_with,
              lambda { |tags|
                Movie.find_options_for_find_tagged_with(tags, :match_all => true)
              }
    
  scope :last_updated,
              lambda {|limit|
                {:order => "updated_at DESC", :limit => limit}
              }

  scope :with_trailer, :conditions => 'trailers is not null and trailers not like ""'
    
  after_save :update_plain_fields
  
  # methods
  def update_plain_fields
    update_plain_cast
    update_plain_directors 
    update_plain_writers
  end

  def update_plain_cast 
    unless self.plain_cast.blank?
      cast = self.plain_cast.split(",")

      # ["Alvaro Pereyra (Yaraher)", "Some one else (Character)"]
      cast.map! do |cast_value|
        if cast_value.include? "("
          cast_value =~ /\s*(.*)\s*(\((.*)\))/
          name, character = $1,$3
          name.strip! if name
        else
          name = cast_value
          character = "" 
        end
        {:name =>name, :character => character} 
      end

      self.movie_characters.each(&:destroy)
      cast.each do |actor|

        person = Person.find_or_create_by_name(actor[:name])
        self.movie_characters.create :person_id => person.id, :character_name => actor[:character]

        #self.chaers << person unless self.characters.include? person
      end
    end
  end
 
   def update_plain_writers
    if plain_writers
      self.writers.each(&:destroy)
      writers = plain_writers.split(",")
      writers.each do |writer|
        writer.strip! if writer
        person = Person.find_or_create_by_name(writer)
        self.writers << person unless self.writers.include? person
      end
    end  
   end

   def update_plain_directors
    if plain_directors
      self.directors.each(&:destroy)
      directors = plain_directors.split(",")
      directors.each do |director|
        director.strip! if director
        person = Person.find_or_create_by_name(director)
        self.directors << person unless self.directors.include? person
      end
    end
   end

  def related_comments
    self.posts.size+self.comments.size
  end

  def good_scores
    Score.count_for_community_approving_movie(self.id) +
    Score.count_for_experts_approving_movie(self.id)
  end

  def bad_scores
    Score.count_for_community_disliking_movie(self.id) +
    Score.count_for_experts_disliking_movie(self.id)
  end

  def list
    self.all
  end

  def mark_as_seen(user)
    unless self.users.include? user
      self.users << user
      self.save
    else
      self.users.delete(user)
      self.save
    end
  end

  %w(genres directors writers).each do |method|
    define_method("#{method}_names") do
      self.send(method).empty? ? '' : self.send(method).map(&:name).join(', ')
    end
  end

  %w(experts community).each do |score_source|
    define_method("score_from_#{score_source}") do
      # Calculates geometric mean for score values
      sql = 'SELECT exp(avg(ln(scores.value))) as value from scores where source like ? and movie_id = ?'
      result =  Movie.find_by_sql([sql, Score::SOURCES[score_source.to_sym], self.id])
      return result.empty? ? 0.0 : result.first.value.to_f
    end
  end

  def calculate_final_score
      Score.calculate_final_score(self.id, self.score_from_community, self.score_from_experts)
  end

  def update_scores
    self.community_score  = self.score_from_community
    self.experts_score    = self.score_from_experts
    self.final_score      = self.calculate_final_score
    self.save
  end

  def self.update_all_scores
    #Movie.all.each do | m |
    #  m.update_scores
    #end
    # TODO: Implement SQL version
  end

  def name_with_year
    year = "(#{self.released_at.year})" if self.released_at
    "#{self.title} #{year}".strip
  end

  def cast_names
    self.movie_characters.empty? ? '' : self.movie_characters.map(&:cast_member).join(', ')
  end

  def short_cast_names
    self.movie_characters.empty? ? '' : self.movie_characters[0..4].map(&:cast_member).join(', ')
  end

  def content
    return summary unless synopsis
    return synopsis unless summary
    
    if summary.size > synopsis.size
      summary
    else
      synopsis
    end
  end

  def to_param
    "#{id}-#{name_with_year.parameterize}"
  end

  def banner?
    self.banner_file_name?
  end

  def cast_and_crew?
    self.directors.try(:count) > 0 and self.writers.try(:count) > 0 and self.characters.try(:count) > 0
  end

  def reference?
    self.title? and self.original_title? and self.released_at? and self.lenght? and self.country? and self.language? and self.mpaa_rate? and self.studio_id?
  end

  def description?
    self.summary? and self.synopsis?
  end

  def complete?
    self.banner? and self.cast_and_crew? and self.reference? and self.description?
  end

  def similars
    Movie.title_like(self.title).id_not_equal_to(self.id).all
  end

  def post_images
    @post_images ||= self.posts.map(&:post_images).flatten
  end

  def post_embeds
    @post_embeds ||= self.posts.map(&:post_embeds).flatten
  end

  def absorb_column(from,to,column)
    to.send("#{column}=",from.send("#{column}")) unless to.send("#{column}")
  end

  def absorb_relationship(from,to,relationship)
    from.send(relationship).each do |relation| to.send(relationship) << relation unless to.send(relationship).include? relation end
  end

  def absorb(absorbed)
    # Information
    columns = %w(title summary synopsis released_at lenght website language original_title studio_id user_id)
    columns.each{|c| absorb_column(absorbed,self,c)}
    # Relationships
    associations = %w(genres directors writers characters fans awards assets scores schedules posts comments)
    associations.each {|a| absorb_relationship(absorbed,self,a)}
    # Save & Destroy
    self.save
    absorbed.destroy
  end

  def absorb_similars
    # TODO: Use absorb for all similar movies
  end
  
  def trailers?
    self.trailers && self.trailers =~ /[object|iframe]/
  end

  def movie_trailers
    @movie_trailers ||= doc.css('iframe').map(&:to_html)
  end
  
  # define_index do
  #   indexes title, :sortable => true
  #   indexes original_title
  #   indexes summary
  #   indexes synopsis
  #   indexes website
  #   indexes cached_tag_list
  #   indexes plain_cast
  #   indexes plain_directors
  #   indexes plain_writers
  #   has user_id, created_at, updated_at
  #   set_property :delta => true
  # end
  
  private

  def doc
    @doc ||= Nokogiri::HTML(self.trailers)
  end

end






# == Schema Information
#
# Table name: movies
#
#  id                  :integer(4)      not null, primary key
#  title               :string(255)
#  summary             :text
#  synopsis            :text
#  released_at         :datetime
#  lenght              :string(255)
#  website             :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  country             :string(255)
#  language            :string(255)
#  mpaa_rate           :string(255)
#  studio_id           :integer(4)
#  community_score     :decimal(5, 2)   default(0.0)
#  experts_score       :decimal(5, 2)   default(0.0)
#  final_score         :decimal(5, 2)   default(0.0)
#  banner_file_name    :string(255)
#  banner_content_type :string(255)
#  banner_file_size    :integer(4)
#  banner_updated_at   :datetime
#  original_title      :string(255)
#  delta               :boolean(1)      default(TRUE), not null
#  user_id             :integer(4)
#  plain_cast          :text
#  plain_directors     :text
#  plain_writers       :text
#  trailers            :text
#  cached_tag_list     :string(255)
#

