class Person < ActiveRecord::Base
  has_attached_file :picture, :styles => {:banner => "150x222#", :medium => "300x300>", :thumb => "100x100>" }, :storage => :s3,
                    :s3_credentials => { :access_key_id => "1B7JJ1RZXMZP7VQADY02" , :secret_access_key =>"8UvZq1RtsyE72t0vq2U1FaaZStGXm9fj87uFub2b" },
                    :path => "system/:attachment/:id/:style/:basename.:extension",
                    :bucket => lambda { |attachment| i = attachment.instance.id;  i = (i ? i % 4 : 0) ;"assets#{i}.votencamotes.com"}
  # relationships
  has_many :as_an_actor_fans,   :class_name => "Profile", :foreign_key => "favorite_actor_id"
  has_many :as_a_writer_fans,   :class_name => "Profile", :foreign_key => "favorite_writer_id"
  has_many :as_a_director_fans, :class_name => "Profile", :foreign_key => "favorite_director_id"
  has_many :movie_directors, :foreign_key => "director_id", :dependent => :destroy
  has_many :directed_movies,  :through => :movie_directors, :source => :movie
  has_many :movie_writers, :foreign_key => "writer_id", :dependent => :destroy
  has_many :written_movies,   :through => :movie_writers, :source => :movie
  has_many :movie_characters, :dependent => :destroy
  has_many :performed_movies, :through => :movie_characters, :source => :movie
  has_many :awards

  after_create :update_names
  after_update :update_names
  # validations
  validates_presence_of   :name
  # validates_uniqueness_of :first_name, :scope => :last_name

  # methods
  def short_name
    self.name unless self.name.nil?
    "#{self.first_name} #{self.last_name}" unless self.last_name.nil?
  end

  # define_index do
  #   indexes first_name
  #   indexes last_name
  #   indexes middle_name
  #   indexes name
  #   has created_at, updated_at
  #   set_property :delta => true
  # end 

  def update_names
    if self.last_name.nil?
      names = self.name.split(" ")
      self.first_name = names.first
      self.last_name = names.last
      self.middle_name = names[1..-2].join(" ")
      self.save
    elsif self.name.nil?
      self.name = "#{self.first_name} #{self.last_name}"
      self.save
    end
  end

  def full_name
    "#{self.first_name} #{self.middle_name} #{self.last_name}"
  end

  # THIS IS REALLY.. REALLY UGLY. GOTTA THING OF A BETTER WAY TO DO IT
  def to_param
    "#{id}-#{try(:first_name).try(:parameterize)}-#{try(:middle_name).try(:parameterize)}-#{try(:last_name).try(:parameterize)}"
  end

  def absorb(absorbed)
    # Information
    self.first_name           = absorbed.first_name           if self.first_name.nil?
    self.middle_name          = absorbed.middle_name          if self.middle_name.nil?
    self.last_name            = absorbed.last_name            if self.last_name.nil?
    self.bio                  = absorved.bio                  if self.bio.nil?
    self.born_at              = absorbed.born_at              if self.born_at.nil?
    self.born_in              = absorbed.born_in              if self.born_in.nil?
    self.url                  = absorbed.url                  if self.url.nil?
    self.picture_file_name    = absorbed.picture_file_name    if self.picture_file_name.nil?
    self.picture_content_type = absorbed.picture_content_type if self.picture_content_type.nil?
    self.picture_file_size    = absorbed.picture_file_size    if self.picture_file_size.nil?
    self.picture_updated_at   = absorbed.picture_updated_at   if self.picture_updated_at.nil?
    self.name                 = absorbed.name                 if self.name.nil?

    # Relationships
    absorbed.directed_movies.each       do |movie|  self.directed_movies    << movie  unless self.directed_movies.include? movie;   end
    absorbed.written_movies.each        do |movie|  self.written_movies     << movie  unless self.written_movies.include? movie;    end
    absorbed.as_a_director_fans.each    do |fan|    self.as_a_director_fans << fan    unless self.as_a_director_fans.include? fan;  end
    absorbed.as_a_writer_fans.each      do |fan|    self.as_a_writer_fans   << fan    unless self.as_a_writer_fans.include? fan;    end
    absorbed.as_an_actor_fans.each      do |fan|    self.as_an_actor_fans   << fan    unless self.as_an_actor_fans.include? fan;    end
    Award.from_person(absorbed.id).each do |award|  award.person = self; award.save; end
    MovieCharacter.from_actor(absorbed.id).each do |movie_character|
      (movie_character.person = self and movie_character.save) unless self.performed_movies.include? movie_character.movie
    end
    self.save
    absorbed.destroy
  end

  def similars
    Person.first_name_like(self.first_name).last_name_like(self.last_name).id_is_not(self.id).all
  end

  def absorb_similars
    self.similars.each do |similar|
      self.absorb(similar)
    end
  end

  def picture?
    self.picture_file_name?
  end

  def identity?
    self.first_name? and self.last_name?
  end

  def birth?
    self.born_at? and self.born_in?
  end

  def roles
    named_roles =  ''
    named_roles << 'Actor'      if self.performed_movies.count > 0
    named_roles << ((named_roles.size > 0 ? ', ' : '') << 'Director')   if self.directed_movies.count > 0
    named_roles << ((named_roles.size > 0 ? ', ' : '') << 'Guionista')  if self.written_movies.count > 0
    named_roles
  end
end




# == Schema Information
#
# Table name: people
#
#  id                   :integer(4)      not null, primary key
#  first_name           :string(255)
#  middle_name          :string(255)
#  last_name            :string(255)
#  born_at              :datetime
#  born_in              :string(255)
#  bio                  :text
#  created_at           :datetime
#  updated_at           :datetime
#  url                  :string(255)
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer(4)
#  picture_updated_at   :datetime
#  name                 :string(255)
#  delta                :boolean(1)      default(TRUE), not null
#

