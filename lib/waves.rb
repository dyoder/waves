# External Dependencies
require 'rubygems'

# Some scripts need to be able to locate items relative to waves source.
WAVES = "#{File.dirname(__FILE__)}/.." unless defined?(WAVES)

require 'rack'
require 'daemons'
require 'live_console'

gem 'dyoder-autocode'
require 'autocode'
require 'functor'

# for mimetypes only or when using as default handler
require 'mongrel'

# a bunch of handy stuff
require 'extensions/io'
require 'extensions/symbol' unless Symbol.instance_methods.include? 'to_proc'
require 'fileutils'
require 'metaid'
require 'forwardable'
require 'date'
require 'benchmark'
# require 'memcache'
require 'base64'

gem 'dyoder-filebase'
require 'filebase'
require 'filebase/model'

# selected project-specific extensions
require 'ext/module'
require 'ext/string'
require 'ext/symbol'
require 'ext/object'
require 'ext/integer'
require 'ext/inflect'
require 'ext/proc'
require 'ext/hash'
require 'ext/tempfile'
require 'ext/kernel'
require 'ext/functor'

# waves Runtime
require 'dispatchers/base'
require 'dispatchers/default'
require 'runtime/logger'
require 'runtime/mime_types'
require 'runtime/runtime'
require 'runtime/console'
require 'runtime/server'
require 'runtime/request'
require 'runtime/response'
require 'runtime/response_mixin'
require 'runtime/session'
require 'runtime/blackboard'
require 'runtime/configuration'

# waves URI mapping
require 'matchers/base'
require 'matchers/accepts'
require 'matchers/content_type'
require 'matchers/path'
require 'matchers/query'
require 'matchers/uri'
require 'resources/mixin'
require 'resources/selector'
require 'resources/path'

# waves mvc support
require 'controllers/mixin'
require 'views/mixin'
# require 'helpers/tag_helper'
# require 'helpers/url_helper'
require 'helpers/common'
require 'helpers/form'
require 'helpers/formatting'
require 'helpers/model'
require 'helpers/view'
require 'helpers/built_in'
# require 'helpers/asset_helper'
# require 'helpers/number_helper'
require 'renderers/mixin'
require 'renderers/erubis'
require 'renderers/markaby'
require 'renderers/haml'


# waves foundations / layers
require 'layers/simple'
require 'layers/simple_errors'
require 'foundations/simple'
require 'layers/mvc'
require 'layers/default_errors'
require 'layers/inflect/english'
require 'foundations/default'
