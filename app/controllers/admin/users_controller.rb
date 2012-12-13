class Admin::UsersController < InheritedResources::Base

  before_filter :authenticate_admin!

  respond_to    :html, :xml
  actions       :all

  def default_path
    admin_users_path
  end

  def index
    @users = User.all
  end

  def update
    if params[:user][:password] && params[:user][:password].empty?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    update!   { default_path }
  end

  def show
    @user = User.find_by_id(params[:id])
    if @user
      show!
    end
  end

end

