module Ricer4::Extend::AuthorIs
  DEFAULT_AUTHORS ||= {
    :gizmore => 'gizmore@wechall.net',
  }
  def author_is(author)
    author = author.is_a?(String) ? author : (DEFAULT_AUTHORS[author] || author.to_s)
    class_eval do |klass|
      klass.register_class_variable(:@author)
      klass.set_class_variable(:@author, author)
      def plugin_author
        get_class_variable(:@author)
      end
    end
  end
  def date_is(date)
    class_eval do |klass|
      klass.register_class_variable(:@plugin_date)
      klass.set_class_variable(:@plugin_date, date)
      def plugin_date
        get_class_variable(:@plugin_date)
      end
    end
  end
end
