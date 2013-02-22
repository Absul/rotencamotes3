class Admin::PostsController < InheritedResources::Base
  before_filter :authenticate_admin!
  respond_to    :html, :xml
  actions       :all

 # uses_tiny_mce(:options => AppConfig.default_mce_options, :only => [:new, :edit])


  def default_path
    admin_posts_path
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

  private
  
  def update_with_movie
    if params[:autocomplete_for_post_movie]
      search_title = params[:autocomplete_for_post_movie]
    
      #Filter it so Iron Man (2010) becomes Iron Man
      search_title = search_title.gsub /\s*\(\d*\)/, ""
      logger.info search_title
      movie = Movie.find_or_create_by_title(search_title)
      movie.user_id = current_user
      movie.save
      @post.movie = movie
      logger.info "Pelicula: #{@post.movie.inspect}"
      
    end
    
  end


end

