module Blog

  module Models

    class Comment < Default
      many_to_one :entry, :class => Blog::Models::Entry
      before_save do
        set_with_params(:updated_on => Time.now) if columns.include? :updated_on
      end
      
      def time
        updated_on.strftime('%I:%M %p on %b %d, %Y')
      end
      
      def attribution
        name.nil? || name.empty?  ? 'anonymous coward' : name
      end
      
    end

  end

end
