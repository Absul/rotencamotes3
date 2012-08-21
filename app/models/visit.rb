# encoding: UTF-8
class Visit < ActiveRecord::Base

  def self.track_visit(request)
    params  = request.path_parameters
    query   = request.query_parameters
    id      = params['id'] if params['id']
    blog_id = Post.find(id).try(:blog).try(:id) if params['controller'] =~ /post/ && id

    Visit.create({
      :url          => request.url,
      :referer      => request.env["HTTP_REFERER"],
      :parent_id    => blog_id,
      :resource_id  => id,
      :action       => params['action'],
      :controller   => params['controller']
    }) 
  end

  scope :for_blog,
                lambda{ |blog_id|{
                  :conditions => {:resource_id => blog_id, :controller => 'blogs'},
                  :order => 'created_at DESC'}
                }
  scope :for_post,
                lambda{ |post_id| {
                  :conditions => {:resource_id => post_id, :controller => 'posts'},
                  :order => 'created_at DESC'
                }}

  def self.update_counters
    connection.update(
            "update blogs set visits_count = (select count(*) from visits where controller = 'blogs' and resource_id = blogs.id) +" +
                                            "(select count(*) from visits where controller = 'posts' and parent_id = blogs.id)"          
       )
    connection.update(
      "update posts set visits_count = (select count(*) from visits where controller = 'posts' and action = 'show' and resource_id = posts.id)"
    )
  end
end

# == Schema Information
#
# Table name: visits
#
#  id          :integer(4)      not null, primary key
#  url         :string(255)
#  referer     :string(255)
#  parent_id   :string(255)
#  resource_id :string(255)
#  action      :string(255)
#  controller  :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

