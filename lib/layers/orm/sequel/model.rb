module Waves
  module Layers
    module ORM
      
      class Model < ::Sequel::Model
        
        before_save do
           set(:updated_on => Time.now) if columns.include? :updated_on
        end
        
      end
    end
  end
end