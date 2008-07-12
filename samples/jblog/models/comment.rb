module Blog

  module Models

    class Comment < Default
      belongs_to :entry, :class_name => 'Blog::Models::Entry'
      before_save do
        update_attributes(:updated_on => Time.now) if columns.include? :updated_on
      end
    end

  end

end
