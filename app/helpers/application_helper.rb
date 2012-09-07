# encoding: utf-8

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def places_to_watch
    # ["Cines", [["United States","US"],["Canada","CA"]]]
    [
       ['Privado',
         Score::OTHER_SOURCES.map{|s| [s[1], "s_#{s[0]}"]},
       ],
       ['Cine',
         Theatre.all.map{|t| [t.name, t.id] }
       ]
      ]
  end

  def display_flashes
     flash_tags = [:error, :warning, :notice, :alert, :ok].map { |type| flash_tag(type, "message #{type}")}.join
     content_tag(:div,flash_tags,{:class=>"flash"})
  end

  def title
    title = ""
    title << "#{@movie.name_with_year} " if @movie
    title << "(#{render_score(@movie.final_score)}) " if @movie && @movie.final_score > 0
    title << "| #{@movie.genres.map(&:name).join(", ")} " if (@movie && (not @movie.genres.empty?))
    title << "#{@post.title} por #{@post.user.full_name} " if @post && @post.user
    title << "#{ @movies[0..5].map(&:name_with_year).join(", ")} " if @movies
    title << "#{@person.name} " if @person
    title << "Cartelera de la semana " if @schedules 
    title << "#{@blog.name} de #{@blog.user.name} " if @blog and @blog.user
    title << "#{@movie_chain.name} | Cadena de cines " if @movie_chain
    title << "Cine #{@theatre.name} " if @theatre
    title << "Películas de #{@genre.name} " if @genre
    title << "Perfil de #{@user.name}" if @user
    title << "Sobre #{@person.name}" if @person
    title << "| VotenCamotes "
    title << "| Una web para los encamotados del cine" unless @movie or @post
    title << "| #{@post.cached_tag_list}" if @post
    title << "| #{@movie.short_cast_names}" if @movie
    title
  end

  def flash_tag(type,tag_class)
    content_tag(:span,flash[type],:class=>tag_class) unless flash[type].blank?
  end


  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def render_score(score = 0)
    if score && score > 0
      number_to_percentage(score, :precision => 0)
    else
      content_tag(:span, "--", :title => "Todavía nadie ha comentado ésta película. ¿Qué esperas?")
    end
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end

  def summary_of(text, lenght = 400)
    raw truncate(strip_tags(text), :lenght => lenght)
  end

  def friendly_pluralize(number, singular, plural = nil)
    if number == 1
      "#{number} #{singular}"
    else
      number.to_s + " "+ (plural.nil? ? singular + 's' : plural)
    end
  end
  def home_page
     controller.controller_name == "home" && controller.action_name == "index" ? "main" : ""
  end

  def smart_connected_as
    current_user.full_name.blank? ? current_user.email : current_user.full_name
  end

  def widget_tag (name = nil, &block)
    haml_tag ".widget" do
      haml_tag ".top"
      haml_tag ".middle" do
        haml_tag :h3, name if name
        haml_concat capture(&block)
      end
      haml_tag ".bottom"
    end
  end

  def active_if_now
    "current" if params[:filter]=="ahora"
  end

  def active_if_showtime
    "current" if params[:filter].nil? or params[:filter]=="estrenos"
  end

  def active_if_recommended
   "current" if params[:filter]=="recomendadas"
  end

  def avatar_tag(user)

    if user
      avatar = link_to image_tag(user.avatar.url(:avatar), :class => "avatar",:title => user.full_name),user
    else
      avatar = image_tag "unknown.png", :class => "avatar", :title => "Desconocido", :size => "64x64"
    end

    content_tag(:div, avatar, :class => "avatar")

  end


end

