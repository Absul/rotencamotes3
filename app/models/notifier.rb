class Notifier < ActionMailer::Base
  # default :from => "sender_email_id"

  def comment_posted(comment,post,user,author)
    subject    "[Votencamotes] Alguien se encamotó con tu camoteada"
    from        "camote@votencamotes.com"
    recipients  author.email
    content_type "text/html"
    body(:post => post, :user => user, :author => author, :comment => comment)
  end
  def recomendation_posted(recomendation)
    subject "[Votencamotes] Un amigo te recomienda una película"
    from "camote@votencamotes.com"
    recipients recomendation.email
    content_type "text/html"
    body(:recomendation => recomendation)
  end
end
