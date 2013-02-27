# encoding: UTF-8
class Schedule < ActiveRecord::Base
  # relationships
  belongs_to            :theatre
  belongs_to            :movie
  belongs_to            :play
  #has_many              :showtimes
  # validations
  validates_presence_of :in_theatre_from
  validates_presence_of :status

  # valid statuses
  STATUSES = {
              :active   =>  'active',
              :inactive =>  'inactive'
  }

  # named scopes
  scope :active,
              :conditions =>  DB_time.new.time_diff('created_at', '(select created_at from schedules order by created_at desc limit 1)') + "= 0"
              
  scope :inactive,
              :conditions =>  DB_time.new.time_diff('created_at', '(select created_at from schedules order by created_at desc limit 1)') + "< 0"
  scope :from_theatre,
                lambda  { |theatre_id|  {
                  :conditions =>  { :theatre_id => theatre_id },
                  :order      =>  'in_theatre_from DESC'
                }
              }
  scope :from_movie,
                lambda  { |movie_id|  {
                  :conditions =>  { :movie_id =>  movie_id  },
                  :order      =>  'in_theatre_from DESC'
                }
              }
  scope :from_movie_chain,
                lambda  { |movie_chain_id|  {
                  :conditions =>  { :theatres => {  :movie_chain_id => movie_chain_id }},
                  :order      =>  'in_theatre_from DESC',
                  :joins      => :theatre
                }

                }

 @sql = DB_time.new.time_diff('schedules.created_at', '(select created_at from schedules order by created_at desc limit 1)')

  # methods
  def activate
    self.status = STATUSES[:active]
    self.save
  end

  def deactivate
    self.status = STATUSES[:inactive]
    self.save
  end

  def active?
    return self.status == STATUSES[:active]
  end

  def inactive?
    return self.status == STATUSES[:inactive]
  end

  def current_showtimes
    #return self.showtimes.active.empty? ? '' : self.showtimes.active.map(&:time_shown_at).join(' | ')
    self.try(:showtimes).try(:strip).try(:delete, ' ').try(:gsub,/,/,' / ')
  end

  def self.scheduled_movies
    
    Movie.find_by_sql(
      'select movies.* from movies where id in (select movie_id from schedules where' + @sql + '= 0 group by movie_id) order by created_at DESC')
  end
  
  def self.scheduled_movies_from_state(state)
    Movie.find_by_sql(
      ['select movies.* from movies join schedules on movies.id = schedules.movie_id join theatres on theatres.id = schedules.theatre_id where'+ @sql + ' = 0 and theatres.state like ? group by movie_id order by movies.created_at DESC',state])    
  end

  def self.scheduled_movies_from_city(city)
    Movie.find_by_sql(
      ['select movies.* from movies where id in (select movie_id from schedules join theatres on theatres.id = schedules.theatre_id where ' + @sql + ' = 0 and theatres.city like ? group by movie_id) order by created_at DESC',city])    
  end

  def self.scheduled_movies_from_now
    Movie.find_by_sql('select movies.* from movies join schedules on movies.id = schedules.movie_id where '+@sql+' = 0 group by movies.id order by final_score desc')
  end

  def self.scheduled_movie_chains_for_movie movie_id
    MovieChain.find_by_sql([
      'select * from movie_chains where id in (select movie_chain_id from theatres where id in (select theatre_id from schedules where'+@sql+'= 0 and movie_id = ?))', movie_id])
  end

  def self.scheduled_theatres_for_movie movie_id
    Theatre.find_by_sql([
      'select * from theatres where id in (select theatre_id from schedules where'+@sql+'= 0 and movie_id = ?) order by name", movie_id])
  end
end


# == Schema Information
#
# Table name: schedules
#
#  id              :integer(4)      not null, primary key
#  theatre_id      :integer(4)
#  movie_id        :integer(4)
#  in_theatre_from :datetime
#  in_theatre_to   :datetime
#  description     :string(255)
#  status          :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  showtimes       :string(255)
#

