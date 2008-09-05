module Waves

  module Matchers

    class ContentType < Base
      
      def initialize( content_type ) ; @constraints = { :content_type => content_type } ; end
    
      # we could maybe do something more sophisticated here, matching against content type patterns
      # such */html or */xml, etc.; adapt from the matching done on accepts ... ?
      def call( request ) ; test( request ) ; end
      
    end
    
  end
  
end