module UsersHelper
  def are_you?(user = @user)
    (current_user == user) #|| admin  # or admin ||
  end
end

