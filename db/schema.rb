# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121213024823) do

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.string   "action"
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["item_type", "item_id"], :name => "index_activities_on_item_type_and_item_id"

  create_table "admins", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["confirmation_token"], :name => "index_admins_on_confirmation_token", :unique => true
  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "ads", :force => true do |t|
    t.string   "name"
    t.string   "campaign"
    t.text     "content"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string   "place"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assets", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "award_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "award_institutions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "bio"
    t.string   "url"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "awards", :force => true do |t|
    t.integer  "institution_id"
    t.integer  "category_id"
    t.integer  "year_received"
    t.string   "status"
    t.integer  "person_id"
    t.integer  "movie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "backup", :force => true do |t|
    t.string   "trigger"
    t.string   "adapter"
    t.string   "filename"
    t.string   "md5sum"
    t.string   "path"
    t.string   "bucket"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_images", :force => true do |t|
    t.integer  "blog_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blogs", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
    t.string   "banner"
    t.integer  "category_id"
    t.boolean  "active"
    t.integer  "posts_count"
    t.integer  "visits_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.text     "description"
  end

  create_table "brain_busters", :force => true do |t|
    t.string "question"
    t.string "answer"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "category_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "permalink"
  end

  create_table "comments", :force => true do |t|
    t.integer  "post_id"
    t.string   "email"
    t.string   "name"
    t.string   "website"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.text     "content"
    t.string   "status"
    t.boolean  "featured"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "movie_id"
  end

  create_table "external_links", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorites", :force => true do |t|
    t.integer  "favoritable_id"
    t.string   "favoritable_type"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.integer  "list_id"
    t.integer  "listable_id"
    t.string   "listable_type"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "lists", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movie_chains", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.text     "bio"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "movie_characters", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "person_id"
    t.string   "character_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movie_directors", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "director_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movie_genres", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "genre_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movie_writers", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "writer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movies", :force => true do |t|
    t.string   "title"
    t.text     "summary"
    t.text     "synopsis"
    t.datetime "released_at"
    t.string   "lenght"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "language"
    t.string   "mpaa_rate"
    t.integer  "studio_id"
    t.decimal  "community_score",     :precision => 5, :scale => 2, :default => 0.0
    t.decimal  "experts_score",       :precision => 5, :scale => 2, :default => 0.0
    t.decimal  "final_score",         :precision => 5, :scale => 2, :default => 0.0
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
    t.string   "original_title"
    t.boolean  "delta",                                             :default => true, :null => false
    t.integer  "user_id"
    t.text     "plain_cast"
    t.text     "plain_directors"
    t.text     "plain_writers"
    t.text     "trailers"
    t.string   "cached_tag_list"
  end

  add_index "movies", ["final_score"], :name => "index_movies_on_final_score"
  add_index "movies", ["title"], :name => "index_movies_on_title"
  add_index "movies", ["updated_at"], :name => "index_movies_on_updated_at"
  add_index "movies", ["user_id"], :name => "index_movies_on_user_id"

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.datetime "born_at"
    t.string   "born_in"
    t.text     "bio"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "name"
    t.boolean  "delta",                :default => true, :null => false
  end

  create_table "photos", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "photo_type"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plays", :force => true do |t|
    t.string   "title"
    t.text     "synopsis"
    t.text     "cast"
    t.string   "director"
    t.string   "author"
    t.datetime "starting_at"
    t.datetime "ending_at"
    t.string   "length"
    t.string   "cached_tag_list"
    t.integer  "theatre_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "post_categories", :force => true do |t|
    t.integer  "post_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.string   "permalink"
    t.integer  "blog_id"
    t.datetime "drafted_at"
    t.datetime "published_at"
    t.datetime "reviewed_at"
    t.string   "cached_tag_list"
    t.integer  "comments_count"
    t.integer  "visits_count"
    t.decimal  "rating",          :precision => 4, :scale => 2, :default => 0.0
    t.boolean  "delta",                                         :default => true
    t.string   "status",                                        :default => "drafted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "movie_id"
    t.text     "headlines"
    t.integer  "play_id"
  end

  create_table "profiles", :force => true do |t|
    t.string   "current_location"
    t.string   "favorite_movie_character"
    t.string   "favorite_movie_line"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "favorite_movie_id"
    t.integer  "favorite_actor_id"
    t.integer  "favorite_genre_id"
    t.integer  "favorite_director_id"
    t.integer  "favorite_writer_id"
    t.string   "favorite_actor"
    t.string   "favorite_director"
    t.string   "favorite_writer"
    t.string   "favorite_movie"
  end

  create_table "recomendations", :force => true do |t|
    t.integer  "movie_id"
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
  end

  create_table "schedules", :force => true do |t|
    t.integer  "theatre_id"
    t.integer  "movie_id"
    t.datetime "in_theatre_from"
    t.datetime "in_theatre_to"
    t.string   "description"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "showtimes"
    t.integer  "play_id"
  end

  create_table "scores", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "user_id"
    t.datetime "scored_at"
    t.string   "source"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "theatre_id"
    t.integer  "comment_id"
    t.string   "other_source"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "showtimes", :force => true do |t|
    t.integer  "schedule_id"
    t.string   "shown_at"
    t.string   "description"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "studios", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.text     "bio"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
  end

  create_table "theatres", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "movie_chain_id"
    t.string   "phone"
    t.string   "lat"
    t.string   "long"
    t.string   "city"
    t.string   "state"
  end

  create_table "tiny_prints", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_file_size"
    t.string   "image_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tiny_videos", :force => true do |t|
    t.string   "original_file_name"
    t.string   "original_file_size"
    t.string   "original_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_movies", :force => true do |t|
    t.integer  "user_id"
    t.integer  "movie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                               :default => "", :null => false
    t.string   "password"
    t.date     "born_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "website"
    t.integer  "member_of_mask",                      :default => 2
    t.integer  "oauth2_uid",           :limit => 8
    t.string   "oauth2_token",         :limit => 149
    t.text     "bio"
    t.string   "one_line_bio"
    t.string   "url"
  end

  add_index "users", ["oauth2_uid"], :name => "index_users_on_oauth2_uid", :unique => true

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "video_type"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "visits", :force => true do |t|
    t.string   "url"
    t.string   "referer"
    t.string   "parent_id"
    t.string   "resource_id"
    t.string   "action"
    t.string   "controller"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "widgets", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "status",     :default => "unactive"
    t.integer  "position",   :default => 1
    t.string   "place",      :default => "left"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
