class Member::PostsController < InheritedResources::Base
  before_filter :authenticate_user!
  respond_to    :html, :xml
  actions       :all

  # uses_tiny_mce(:options => AppConfig.default_mce_options, :only => [:new, :edit])

  def default_path
    member_posts_path
  end

  def new
    puts params[:type]
    @post = current_user.build_post
    new!
  end

  def create
    @post = Post.new(params[:post])
    
    update_with_movie
    
    case (params[:commit])
      when 'Crear' then
        @post.setup_to_mark_as_drafted
      when 'Publicar' then
        @post.setup_to_mark_as_published
    end
    # Score the movie
    Score.rate(current_user, @post.movie_id, nil, @post.rating,nil) if params[:commit]
    create! { default_path }
  end

  def update
    @post = Post.find(params[:id])
    @post.attributes = params[:post]
    update_with_movie
    case (params[:commit])
      when 'Publicar' then
        @post.setup_to_mark_as_published
      when 'A borrador' then
        @post.setup_to_mark_as_drafted
      when 'Actualizar' then
        @post.setup_to_mark_as_drafted
    end
    # Score the movie
    Score.rate(current_user, @post.movie_id,nil,@post.rating,nil) if params[:commit]
    update!   { default_path }
  end

  def destroy
    destroy!  { default_path }
  end
  
  def search
    @search = Movie.searchlogic((params[:search]||params["tab"]))
    @movies = @search.paginate(:page => params[:page])
    logger.info @search.inspect
    logger.info @movies.inspect
    
    respond_to do |format|
      format.html { render :json => @movies.map { |movie| {:label => movie.name_with_year, :value => movie.id} }.to_json }
      format.json { render :json => @movies.map{ |movie| {:label => movie.name_with_year, :value => movie.id} }.to_json }
      format.js { render :json => @movies.map{ |movie| {:label => movie.name_with_year, :value => movie.id} }.to_json }
    end
  end
   def search_movie
    @search = Movie.search(params["tag"])
    @movies = @search.paginate(:page => params[:page],:per_page => 20)
    logger.info @search.inspect
    logger.info @movies.inspect
    
    respond_to do |format|
      format.html { render :json => @movies.map { |movie| {:key => movie.name_with_year, :value => movie.id} }.to_json }
      format.json { render :json => @movies.map{ |movie| {:key => movie.name_with_year, :value => movie.id} }.to_json }
      format.js { render :json => @movies.map{ |movie| {:key => movie.name_with_year, :value => movie.id} }.to_json }
    end
  end
   
  private
  
  def update_with_movie
    if params[:autocomplete_for_post_movie]
      search_title = params[:autocomplete_for_post_movie]
    
      # Filter it so Iron Man (2010) becomes Iron Man
      search_title = search_title.gsub /\s*\(\d*\)/, ""
      logger.info search_title
      unless search_title.blank?
        movie = Movie.find_or_create_by_title(search_title)
        movie.user_id = current_user
        movie.save
        @post.movie = movie
        logger.info "Pelicula: #{@post.movie.inspect}"
      end
    end
  end

end

