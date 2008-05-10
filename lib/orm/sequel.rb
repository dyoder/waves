require 'sequel'

module Waves
  module Orm

    Model = ::Sequel::Model

    module Sequel
      
      def self.included( app )
        def app.sequel ; @sequel ||= ::Sequel.open( config.database ) ; end
        def app.database ; @database ||= sequel ; end
        def app.model_config(context, name); context.set_dataset(database[ name ]); end
      end

    end
  end
end

if defined?(Rake)
  require File.dirname(__FILE__) / :sequel / :tasks / :schema
end
