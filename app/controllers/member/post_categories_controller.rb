class Member::PostCategoriesController < InheritedResources::Base
  before_filter :authenticate_user!
  respond_to    :html, :xml
  actions       :all

  def default_path
    member_post_categories_path
  end

  def create
    create! { default_path }
  end

  def destroy
    destroy!  { default_path }
  end

end

