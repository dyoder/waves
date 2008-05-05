module Blog
  module Configurations
    module Mapping
      extend Waves::Mapping

      path %r{^/comments/?$}, :method => :post do
        use( :comment ); comment = controller { create }
        redirect( "/entry/#{comment.entry.name}" )
      end

      include Waves::Mapping::PrettyUrls::RestRules
      include Waves::Mapping::PrettyUrls::GetRules
    end
  end
end
