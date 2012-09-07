atom_feed do |feed|
  feed.title("votencamotes.com Camoteadas | " + @blog.name + " por " + @blog.user.full_name)
  feed.updated(@blog.posts.last.published_at)

  @blog.posts.each do |post|
    feed.entry(post,:url=>post_path(post.id)) do |entry|
      entry.title(post.title)
      entry.content( post.content, :type=>'html')
      entry.author { |author| author.name( @blog.user.full_name ) }
    end
  end
 end

