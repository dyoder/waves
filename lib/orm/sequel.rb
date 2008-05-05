require 'sequel'

module Waves
  module Orm

    Model = ::Sequel::Model

    module Sequel

      def sequel ; @sequel ||= ::Sequel.open( config.database ) ; end
      def database ; @database ||= sequel ; end
      def model_config(context, name); context.set_dataset(database[ name ]); end

    end
  end
end

::Application.extend(Waves::Orm::Sequel)

if defined?(Rake)
  require File.dirname(__FILE__) / :sequel / :tasks / :schema
end
