Rotencamotes3::Application.routes.draw do
root :to => "home#index"

#   match "/indexDaso" => "indexDaso"
#   match "/home_b" => "index_b"  
#   match "/mobile" => "mobile"



#   match "/oscars2011" => "oscars" 
match "/camoteadas/filter/:filter" => "index#filter_posts"

#   resources :lists

#   resources :widgets
resources :user_movies
devise_for :users
#   devise_for :admins
#   match "/about" => "about#index", :path => "acerca" 
#   resources :scores, :path => "puntajes"

 resources :schedules, :path =>"cartelera"
#   match "/peliculas/filtradas/:state" => "schedules#by_state", :path => "movies_by_state"
#   resources :movie_characters, :path => "actores"
#   resources :awards, :path => "premios"
#   resources :award_categories
#   resources :award_institutions
#   resources :videos
#   resources :photos, :path => "fotos"
resources :post_categories
#   resources :ads, :path => "anuncios"
resources :comments, :path => "comentarios"
resources :posts, :path => "camoteadas"
#   resources :blog_images
resources :blogs, :shallow => true do 
  resources :posts do
     resources :comments
     resources :post_categories
  end
end
#   resources :categories, :path => "categorias"
#   resources :external_links
#   resources :pathsets
#   resources :studios, :path => "estudios"
resources :movie_chains, :path => "cadenas"
#   resources :theatres, :path => "cines"
#   resources :profiles, :path => "perfiles"
resources :users, :path => "usuarios"
resources :genres, :path => "generos"
#   resources :people, :path => "personas"
resources :movies, :path=>"peliculas" do
   collection do
     get 'latest'
   end
   member do
     post 'mark_as_seen'
     get 'comment'
     get 'trailer'
     get 'recomend'
     post 'send_recomend'
   end
   resources :posts
 end
# match "/peliculas/filtradas/:state" => "schedules#by_state", :path => "movies_by_state"
# match "/etiquetas/:tag" => "tags", :path => "show"
  
#   # The priority is based upon order of creation:
#   # first created -> highest priority.

#   # Sample of regular route:
#   #   match 'products/:id' => 'catalog#view'
#   # Keep in mind you can assign values other than :controller and :action

#   # Sample of named route:
#   #   match 'products/:id/purchase' => 'catalog#purchase', :path => :purchase
#   # This route can be invoked with purchase_url(:id => product.id)

#   # Sample resource route (maps HTTP verbs to controller actions automatically):
#   #   resources :products

#   # Sample resource route with options:
#   #   resources :products do
#   #     member do
#   #       get 'short'
#   #       post 'toggle'
#   #     end
#   #
#   #     collection do
#   #       get 'sold'
#   #     end
#   #   end

#   # Sample resource route with sub-resources:
#   #   resources :products do
#   #     resources :comments, :sales
#   #     resource :seller
#   #   end

#   # Sample resource route with more complex sub-resources
#   #   resources :products do
#   #     resources :comments
#   #     resources :sales do
#   #       get 'recent', :on => :collection
#   #     end
#   #   end

#   # Sample resource route within a namespace:
#   #   namespace :admin do
#   #     # Directs /admin/products/* to Admin::ProductsController
#   #     # (app/controllers/admin/products_controller.rb)
#   #     resources :products
#   #   end

#   # You can have the root of your site routed with "root"
#   # just remember to delete public/index.html.
#   # root :to => "welcome#index"

#   # See how all your routes lay out with "rake routes"

#   # This is a legacy wild controller route that's not recommended for RESTful applications.
#   # Note: This route will make all actions in every controller accessible via GET requests.
#   # match ':controller(/:action(/:id(.:format)))'


# namespace :admin do 
#   root => "home#index"
#    resources :ads
#    resources :pathsets
#     resources :award_categories
#     resources :award_institutions
#     resources :awards
resources :blogs
#     resources :categories
#     resources :comments
#     resources :external_links
resources :genres
#     resources :movie_chains
#     resources :movie_characters
#     resources :movie_directors
#     resources :movie_writers
#     resources :movies, :collection => {:search => :get}
#     resources :people
#     resources :photos
#     resources :post_categories
#     resources :posts
#     resources :profiles
#     resources :schedules
#     resources :scores
#     resources :studios
#     resources :theatres
resources :lists
#     resources :users
#     resources :videos
#     resources :tags
# end

#  match '/admin/movies/:id/absorb/:similar_id' => "admin/movies", :path => absorb_admin_movie 
  
#  namespace :member do 
#     match "/post/search.:format" => "post#search", :path => autocomplete_movies 
#     match "/post/search_movie.:format" => "post#search_movie", :path  => autocomplete_movie_list

#     resources :pathsets
#     resources :blog_images
#     resources :posts
#     resources :categories
#     resources :post_categories
#     resources :lists, :has_many => :items
#     resources :blogs
#   end
  
#   namespace :mobile do 
#     resources :posts
#     resources :movies
#     resources :comments
#   end


#   # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
#   # map.root :controller => "welcome"

#   # See how all your routes lay out with "rake routes"

#   # Install the default routes as the lowest priority.
#   # Note: These default routes make all actions in every controller accessible via GET requests. You should
#   # consider removsing or commenting them out if you're using named routes and resources.

#   # map routes
  
#   match "/sitemap.xml" => "sitemap"
  match "/search" => "home#search"
#   match ':controller/:action/:id'
#   match ':controller/:action/:id.:format'
#   match "/feed" => "home#index", :format => "atom"
#   match ':acerca/' => 'about#index'
# end


end
