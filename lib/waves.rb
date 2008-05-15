# External Dependencies
require 'rubygems'

require 'rack'
require 'daemons'
require 'live_console'

gem 'dyoder-autocode'
require 'autocode'

# for mimetypes only or when using as default handler
require 'mongrel'

# a bunch of handy stuff
require 'extensions/all'
require 'fileutils'
require 'metaid'
require 'forwardable'
require 'date'
require 'benchmark'
# require 'memcache'
require 'base64'

# selected project-specific extensions
require 'utilities/module'
require 'utilities/string'
require 'utilities/symbol'
require 'utilities/kernel'
require 'utilities/object'
require 'utilities/integer'
require 'utilities/inflect'
require 'utilities/proc'
require 'utilities/hash'
# waves Runtime
require 'dispatchers/base'
require 'dispatchers/default'
require 'runtime/logger'
require 'runtime/mime_types'
require 'runtime/application'
require 'runtime/console'
require 'runtime/debugger'
require 'runtime/server'
require 'runtime/request'
require 'runtime/response'
require 'runtime/response_mixin'
require 'runtime/response_proxy'
require 'runtime/session'
require 'runtime/configuration'

# waves URI mapping
require 'mapping/mapping'
require 'mapping/pretty_urls'

# waves mvc support
require 'controllers/mixin'
require 'controllers/base'
require 'views/mixin'
require 'views/base'
require 'renderers/mixin'
require 'renderers/markaby'
require 'helpers/tag_helper'
require 'helpers/url_helper'
require 'renderers/erubis'
require 'helpers/common.rb'
require 'helpers/form.rb'
require 'helpers/formatting.rb'
require 'helpers/model.rb'
require 'helpers/view.rb'
require 'helpers/base'

# waves test support
require 'verify/mapping.rb'
require 'verify/request.rb'

# waves foundations / layers
require 'layers/simple'
require 'layers/simple_errors'
require 'foundations/simple'
require 'layers/mvc'
require 'layers/default_errors'
require 'foundations/default'
