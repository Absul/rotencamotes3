class Admin::PeopleController < InheritedResources::Base
  before_filter :authenticate_admin!
  respond_to    :html, :xml
  actions       :all

  def collection
    @people ||= end_of_association_chain.paginate(:page => params[:page], :order => "first_name, last_name")
  end

  def default_path
    admin_people_path
  end

  def create
    create!   { default_path }
  end

  def update
    @person = Person.find(params[:id])
    @person.attributes = params[:person]
    @person.absorb_similars if params[:commit] == 'Corregir'
    update!   { default_path }
  end

  def destroy
    destroy!  { default_path }
  end


end

