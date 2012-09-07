atom_feed do |feed|
    feed.title("Votencamotes.com | El sitio para los encamotados del cine ")
    feed.updated(@posts.last.published_at)

    @posts.each do |post|
      feed.entry(post,:url=>post_path(post.id)) do |entry|
        entry.title(post.title)
        entry.content( post.content, :type=>'html')
        entry.author { |author| author.name( post.blog.user.full_name ) }
      end
    end

end

