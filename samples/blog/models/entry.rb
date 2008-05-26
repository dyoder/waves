module Blog

  module Models

    class Entry < Default
      one_to_many :comments, :class => Blog::Models::Comment, :key => :entry_id, :order => :updated_on
      before_save do
        set_with_params(:updated_on => Time.now) if columns.include? :updated_on
      end

    end

  end

end
