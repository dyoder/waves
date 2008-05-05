module Blog
  
  module Models
    
    class Comment < Sequel::Model(:comments)      
      before_save do
        set(:updated_on => Time.now) if columns.include? :updated_on
      end
      one_to_one :entry, :from => Blog::Models::Entry
    end
    
  end
  
end