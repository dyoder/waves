module Blog

  module Models

    class Entry < Default
      has_many :comments, :class_name => 'Blog::Models::Comment', :foreign_key => :entry_id, :order => :updated_on
      before_save do
        update_attributes(:updated_on => Time.now) if columns.include? :updated_on
      end

    end

  end

end
