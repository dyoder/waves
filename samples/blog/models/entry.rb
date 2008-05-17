module Blog

  module Models

    class Entry < Default
      one_to_many :comments, :class => Blog::Models::Comment, :key => :entry_id
    end

  end

end
