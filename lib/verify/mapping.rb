module Waves
  module Verify
    module Helpers
      module Mapping

        def mapping
          ::Waves::Application.instance.mapping
        end

        def path(*args,&block)
          mapping.path(*args,&block)
        end

        def url(*args,&block)
          mapping.url(*args,&block)
        end
        
        def always(*args,&block)
          mapping.always(*args,&block)
        end
        
        def handle(*args,&block)
          mapping.handle(*args,&block)
        end

        def threaded(*args,&block)
          mapping.threaded(*args,&block)
        end
        
        def generator(*args,&block)
          mapping.generator(*args,&block)
        end

      end
    end
  end
end
