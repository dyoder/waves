module Blog

  module Configurations

    class Production < Default
      
      debug false
      reloadable []
      log :level => :warn, :output => ( :log / "waves.production" )
      host '0.0.0.0'
      port 4000

    end
  end
end
