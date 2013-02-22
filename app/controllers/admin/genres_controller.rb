class Admin::GenresController < InheritedResources::Base
  before_filter :authenticate_admin!
  respond_to    :html, :xml
  actions       :all

  def collection
    @genres ||= end_of_association_chain.paginate(:page => params[:page], :order => "name")
  end

  def default_path
    admin_genres_path
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

