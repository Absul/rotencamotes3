class Score < ActiveRecord::Base
  # relationships
  belongs_to              :movie
  belongs_to              :user
  belongs_to              :theatre
  belongs_to              :comment

  # validations
  validates_presence_of   :movie
  validates_presence_of   :user
  validates_presence_of   :value
  validates_presence_of   :scored_at
  # validates_uniqueness_of :movie_id, :case_sensitive => true, :scope => [:user_id, :scored_at]

  SOURCES = {
    :community  =>  'community',
    :experts    =>  'experts'
  }

  OTHER_SOURCES = {
    :cable        =>  'Televisión / Cable',
    :download     =>  'Descarga',
    :dvd          =>  'Blu-Ray / DVD',
    :streaming    =>  'Streaming / Via Internet'
  }

  EXPERTS_FACTOR    = 1
  COMMUNITY_FACTOR  = 20
   
  after_save :update_scores

  record_activity_of :user, :actions => [:create]

  def update_scores
    self.movie.update_scores if self.movie
  end


  # named scopes
  named_scope :from_other_sources, :conditions=>"other_source IS NOT NULL", :order=>"scored_at DESC"
  named_scope :from_movie,
              lambda { |movie_id| {
                  :conditions =>  { :movie_id => movie_id },
                  :order      =>  'scored_at DESC'
                }
              }

  named_scope :from_theatre,
              lambda { |theatre_id| {
                  :conditions =>  { :theatre_id => theatre_id },
                  :order      =>  'scored_at DESC'
                }
              }


  named_scope :with_value,
              lambda { |value| {
                  :conditions => {:value => value},
                  :order      => 'scored_at DESC'
                }
              }

  named_scope :with_value_greater_than,
              lambda { |value| {
                  :conditions => ["value >= ?",value],
                  :order      => 'scored_at DESC'
                }
              }

  named_scope :with_value_less_than,
              lambda { |value| {
                  :conditions => ["value < ?",value],
                  :order      => 'scored_at DESC'
                }
              }


  named_scope :from_user,
              lambda { |user_id| {
                  :conditions =>  { :user_id => user_id },
                  :order      =>  'scored_at DESC'
                }
              }

  named_scope :from_experts,
              :conditions =>  { :source  => SOURCES[:experts]  },
              :order      =>  'movie_id, user_id, scored_at DESC'

  named_scope :from_community,
              :conditions =>  { :source  => SOURCES[:community]  },
              :order      =>  'movie_id, user_id, scored_at DESC'

  # methods
  
  def from_community?
    source == SOURCES[:community]
  end
  
  def from_expert?
    source == SOURCES[:experts]
  end
  
  def community_aproving_score?
    value > 3
  end

  def self.count_for_community_approving_movie(movie_id)
    self.from_community.from_movie(movie_id).with_value(5).count
  end

  def self.count_for_experts_approving_movie(movie_id)
    self.from_experts.from_movie(movie_id).with_value_greater_than(65).count
  end

  def self.count_for_experts_disliking_movie(movie_id)
    self.from_experts.from_movie(movie_id).with_value_less_than(65).count
  end



  def self.calculated_for_theatre(theatre_id, movie_id)
    community_scores = Score.from_community.from_movie(movie_id).from_theatre(theatre_id).average('value')
    experts_scores = Score.from_experts.from_movie(movie_id).from_theatre(theatre_id).average('value')
    Score.calculate_final_score(movie_id,community_scores,experts_scores)
  end

  def self.count_for_community_disliking_movie(movie_id)
    self.from_community.from_movie(movie_id).with_value(1).count
  end

  def self.from_community_for_movie(movie_id)
    return self.from_community.from_movie(movie_id).average('value')
  end

  def self.from_experts_for_movie(movie_id)
    return self.from_experts.from_movie(movie_id).average('value')
  end

  def self.able_to_rate_movie(user, movie_id)
    user.scores.from_movie(movie_id).find_all_by_scored_at(Date.today).empty?
  end

  def self.rate(user, movie_id, theatre_id, value, comment_id = nil,other_source = nil, orphan = nil)

    if comment_id || orphan
      source = User::ROLES[:community]
    else
      source = user.scores_as
    end


    if able_to_rate_movie(user, movie_id)
      score               = Score.new
      score.user_id       = user.id
      score.comment_id    = comment_id
      score.movie_id      = movie_id
      score.theatre_id    = theatre_id
      score.value         = value
      score.scored_at     = Date.today
      score.source        = source
      score.other_source  = other_source
      score.save unless (value == 0 || value.nil?)
      logger.info score.errors.full_messages
      logger.info "Se puede crear"
      true
    else
      logger.info "No se puede crear"
      false
    end
  end

  def self.expert_weight(movie_id)
    Score.from_community.find_all_by_movie_id(movie_id).empty? ? 1.0 : 0.6
  end

  def self.community_weight(movie_id)
    Score.from_experts.find_all_by_movie_id(movie_id).empty? ? 0.6 : 0.4
  end

  def self.calculate_final_score(movie_id, score_from_community = 0, score_from_experts = 0)
    score_from_community ||= 0
    score_from_experts ||= 0
    return (score_from_community*community_weight(movie_id)*COMMUNITY_FACTOR +
           score_from_experts*expert_weight(movie_id)*EXPERTS_FACTOR).round(2)
  end

end




# == Schema Information
#
# Table name: scores
#
#  id           :integer(4)      not null, primary key
#  movie_id     :integer(4)
#  user_id      :integer(4)
#  scored_at    :datetime
#  source       :string(255)
#  value        :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  theatre_id   :integer(4)
#  comment_id   :integer(4)
#  other_source :string(255)
#

