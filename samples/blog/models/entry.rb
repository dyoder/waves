module Blog

  module Models

    class Entry < Default
      one_to_many :comments, :class => Blog::Models::Comment, :key => :entry_id, :order => :updated_on
      before_save do
        set_with_params(:updated_on => Time.now) if columns.include? :updated_on
      end
      
      def date
        updated_on.strftime('%b %d, %Y')
      end
      
      def comment_number
        n = comments.size
        case n
        when 0
          "No Comments"
        when 1
          "1 Comment"
        else
          "#{n} Comments"
        end
      end

    end

  end

end
