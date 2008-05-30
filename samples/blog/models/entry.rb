module Blog

  module Models

    class Entry < Sequel::Model
      one_to_many :comments, :class => Blog::Models::Comment, :key => :entry_id
    end

  end

end
