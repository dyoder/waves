module Blog
  module Configurations
    class Default < Waves::Configurations::Default
      
      resources do
        
        mount :entry, [ 'entry' ]
        mount :entry, [ 'entry', { :rest => true } ]
        
      end      
      
    end
  end
end