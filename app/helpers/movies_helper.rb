module MoviesHelper
  def render_genres_links
      @movie.genres.map {|g| link_to g.name, g}.join(', ')
  end

  def edit_person(person)
    if current_user && current_user.admin?
      link_to("Editar",edit_admin_person_path(person),:class => "edit") 
		else
			""
    end
  end

  def render_cast_links
    if @movie.movie_characters.empty?
      "Ninguno registrado"
    else
    @movie.movie_characters.find(:all, :include => :person).map {|c| "#{link_to(c.cast_member, c.person)} #{edit_person(c.person)}" }.join(', ')
    end
  end

  def render_directors_links
    if @movie.movie_directors.empty?
      "Ninguno registrado"
    else
      @movie.movie_directors.map do |d| 
				link_to( d.try(:director).try(:full_name), d.director)  + edit_person(d.director) if d.director && d.director.full_name
			end.join(', ')
    end
  end

  def render_writers_links
    if @movie.movie_writers.empty?
      "Ninguno registrado"
    else
      @movie.movie_writers.map {|w| (link_to(w.writer.full_name, w.writer) +  edit_person(w.writer)) if w.writer }.join(', ')
    end
  end

  def score_icon(score)
    if score
      score.value == 5 ? "camote" : "rotten"
    end
  end

  def share_twitter_link
    
    link = URI.encode("Recomiendo #{@movie.name_with_year} via @votencamotes - #{movie_url(@movie)}")
    
    return "http://twitter.com/home?status=" + link
  end

end

