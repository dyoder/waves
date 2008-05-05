module Waves
  module Helpers
    
    # Model helpers allow you to directly access a model from within a view.
    # This is useful when creating things like select boxes that need data
    # from anther model. For example, a Markaby select box for authors might look like:
    #
    #   select do
    #     all(:user).each do |user|
    #       option user.full_name, :value => user.id
    #     end
    #   end
    #
    # You could also use these within a view class to keep model-based logic out
    # of the templates themselves. For example, in the view class you might define
    # a method called +authors+ that returns an array of name / id pairs. This could
    # then be called from the template instead of the model helper.
    #
    module Model
      
      # Just like model.all. Returns all the instances of that model.
      def all( model )
        Waves.application.models[ model ].all( domain )
      end
      
      # Finds a specific instance using the name field
      def find( model, name )
        Waves.application.models[ model ][ :name => name ] rescue nil
      end
      
    end
  end
end