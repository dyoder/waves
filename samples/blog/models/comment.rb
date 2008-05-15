module Blog

  module Models

    class Comment < Base
      many_to_one :entry, :from => Blog::Models::Entry
    end

  end

end
