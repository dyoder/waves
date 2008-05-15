module Blog

  module Models

    class Comment < Default
      many_to_one :entry, :from => Blog::Models::Entry
    end

  end

end
