module DefaultApplication

  module Models
    
    class Default < ::Sequel::Model
      
      def self.crayola; true; end
      
    end

  end

end
