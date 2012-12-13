class Admin::MoviesController < InheritedResources::Base
  before_filter :authenticate_admin!
  respond_to    :html, :xml
  actions       :all

  def collection
    @movies ||= end_of_association_chain.paginate(:page => params[:page], :order => "title")
  end

  def default_path
    admin_movies_path
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

  def search
    @search = Movie.searchlogic(params[:search])
    @movies = @search.paginate(:page => params[:page])
    respond_to do |format|
      format.html {}
      format.json { @movies.map { |movie| {:label => movie.name_with_year, :value => movie.id} }.to_json }
    end
  end

  def absorb
    movie = Movie.find(params[:id])
    similar = Movie.find(params[:similar_id])
    movie.absorb(similar)
    redirect_to(edit_admin_movie_path(movie))
  end

end

