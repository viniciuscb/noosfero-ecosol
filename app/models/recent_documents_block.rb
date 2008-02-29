class RecentDocumentsBlock < Block

  def self.description
    _('List of recent content')
  end

  settings_items :limit

  include ActionController::UrlWriter
  def content
    docs =
      if self.limit.nil?
        owner.recent_documents
      else
        owner.recent_documents(self.limit)
      end

    docs = docs.select{|d| d.kind_of?(TextArticle)}

    block_title(_('Recent content')) +
    content_tag('ul', docs.map {|item| content_tag('li', link_to(item.title, item.url))}.join("\n"))

  end

end
