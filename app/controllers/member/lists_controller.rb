class Member::ListsController < InheritedResources::Base

  before_filter :authenticate_user!

 def default_path
    user_path(current_user, :anchor => "lists")
  end

  def create
    create_items
    create! do |success,failure|
      success.html {
      
        @list.create_items(@items)
        redirect_to user_path(@list.user)
      }
      failure.html { 
        render :new
      }
    end
  end

  def update
    create_items
    update! do 
      
      @list.create_items(@items)
      default_path
      
    end
  end

  def create_items
    @items = params[:list].delete("items")
  end

  def destroy
    destroy!  { default_path }
  end

end
