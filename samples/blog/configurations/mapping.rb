module Blog

  module Configurations

    module Mapping
      extend Waves::Mapping

      path '/comments', :method => :post do
        with(:comments).create.and.redirect( :model => :entry, :name => instance.name )
      end
      include Waves::Mapping::PrettyUrls::RestRules
      include Waves::Mapping::PrettyUrls::GetRules
    end

  end

end
