# encoding: UTF-8
class	HomeController	<	ApplicationController

	skip_before_filter	:verify_authenticity_token	#,	:only	=>	[:search,]:search

	def	mobile
		load_home(true)
		render	:mobile,	:layout	=>	"mobile"
	end
	
	def	load_home(mobile=false)
		if	params[:filter]
			case	params[:filter]
			when	"ahora"
				@movies	=	Schedule.scheduled_movies_from_now
			when	"estrenos"
				@movies	=	Movie.on_theatres
			when	"recomendadas"
				@movies	=	Movie.recommended(20)
			end
		else
			unless	mobile
				@movies	=	Movie.on_theatres
			else
				@movies	=	Schedule.scheduled_movies_from_now
			end
		end

		logger.info	"Mandando	#{@movies.size}	películas"

		@schedules	=	Schedule.scheduled_movies_from_now	#state("Lima")
		limit = @schedules.size - 2
		limit = 2 if limit <= 0
		limit ||= 2
		@posts	=	Post.last_published(limit).find(:all,	:include	=>	[:movie,	:user])

		@last	=	Movie.with_trailer.last_updated(1).first
		#@schedules	=	[]
		@comments	=	Comment.last_published(15).find(:all,	:include	=>	[:user,:movie,:post])
		@categories	=	Category.with_posts
		@activities	=	Activity.find(:all,	:limit	=>	8,	:order	=>	"created_at	DESC",	:group	=>	"item_id")
    @lists = List.find(:all, :limit => 5, :order => "created_at DESC")
    
	end
	

	def	index
		load_home
		
		respond_to	do	|wants|
			logger.info	"Por	aqui"
			wants.html	#	=>
			wants.js	do
					render	:update	do	|page|
						page.replace	"movies_top",	:partial	=>	"banner"	#,	:collection	=>	@movies
					end
			end
			wants.atom	{	logger.info	"Cae	por	acá"	}
			end
	end

	def	search
		@results	=	ThinkingSphinx.search(params[:search],	:retry_stale	=>	true)
	end

	def	filter_posts
		case	params[:filter]	
			when	"todos"
			@posts	=	Post.last_published(13).find(:all,	:include	=>	[:movie,	:user])
			else
			@posts	=	Post.last_published(13).from_named_category(params[:filter]).find(:all,	:include	=>	[:movie,	:user])
		end
		render	:update	do	|page|
			page.replace_html	"post_collection",	:partial	=>	"home/posts"
			page	<<	'$(".loader").hide();
'		end

	end
	
	def	indexDaso
		load_home
	end
	def	index_b
		load_home
	end


end

