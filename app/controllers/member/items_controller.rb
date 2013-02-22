class Member::ItemsController < InheritedResources::Base
  belongs_to :list
  before_filter :authenticate_user!

 def default_path
    edit_member_list_path(@list)
  end

  def create
    create! { default_path }
  end

  def update
    update! { default_path }
  end

  def destroy
    destroy!  { default_path }
  end


end
