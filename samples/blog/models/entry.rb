module Blog

  module Models

    class Entry < Sequel::Model(:entries)
      before_save do
        set(:updated_on => Time.now) if columns.include? :updated_on
      end
      one_to_many :comments, :from => Blog::Models::Comment, :key => :entry_id
    end

  end

end
