require 'uri'

class Admin::TagsController < InheritedResources::Base
  before_filter :authenticate_admin!
  respond_to    :html, :xml
  actions       :all

  def default_path
    admin_tags_path
  end

  def index
    @tags = Tag.find(:all, :order => 'name ASC')
    index!    { default_path }
  end
  
  def create
    create!   { default_path }
  end

  def update
    tag = params[:id]
    @tag = Tag.find_by_name(tag)
    update! { default_path }
  end
  
  def delete
    tag = URI.unescape(params[:id])
    @tag = Tag.find_by_id(tag)
    logger.info @tag.name
    delete! { default_path }
  end

end