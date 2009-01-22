# TODO: Move ALL of this stuff where it is needed to avoid
#       unnecessary dependencies.

# External Dependencies
require "rubygems"
  require 'rack'
  require 'rack/cache'
  require 'daemons'

  # a bunch of handy stuff
  require 'extensions/io'
  require 'extensions/symbol' unless Symbol.instance_methods.include? 'to_proc'
  require 'fileutils'
  require 'metaid'
  require 'forwardable'
  require 'date'
  require 'benchmark'
  require 'base64'
  require 'functor'
  require 'filebase'
  require 'filebase/model'
  require 'english/style'


# selected project-specific extensions
require 'waves/ext/integer'
require 'waves/ext/float'
require 'waves/ext/string'
require 'waves/ext/symbol'
require 'waves/ext/hash'
require 'waves/ext/tempfile'
require 'waves/ext/module'
require 'waves/ext/object'
require 'waves/ext/kernel'

# waves Runtime
require 'waves/servers/base'
require 'waves/servers/webrick'
require 'waves/servers/mongrel'
require 'waves/dispatchers/base'
require 'waves/dispatchers/default'
require 'waves/runtime/logger'
require 'waves/runtime/mime_types'
require 'waves/runtime/runtime'
require 'waves/runtime/worker'
require 'waves/runtime/request'
require 'waves/runtime/response'
require 'waves/runtime/response_mixin'
require 'waves/runtime/session'
require 'waves/runtime/configuration'
require 'waves/caches/simple'

# waves URI mapping
require 'waves/matchers/base'
require 'waves/matchers/accept'
require 'waves/matchers/content_type'
require 'waves/matchers/path'
require 'waves/matchers/query'
require 'waves/matchers/traits'
require 'waves/matchers/uri'
require 'waves/matchers/request'
require 'waves/matchers/resource'
require 'waves/resources/paths'
require 'waves/resources/mixin'

require 'waves/views/mixin'
require 'waves/views/errors'
require 'waves/renderers/mixin'

