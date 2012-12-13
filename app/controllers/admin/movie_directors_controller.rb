class Admin::MovieDirectorsController < InheritedResources::Base
  before_filter :authenticate_admin!
  respond_to    :html, :xml
  actions       :all

  def default_path
    admin_movie_directors_path
  end

  def index
    @movies = Movie.find(:all, :joins => "INNER JOIN movie_directors on movies.id = movie_directors.movie_id", :group => "movies.id")
    index!
  end

  def create
    create!   { default_path }
  end

  def update
    update!   { default_path }
  end

  def destroy
    destroy!  { default_path }
  end

end

