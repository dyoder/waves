require 'rubygems'; %w{ bacon facon }.each { |dep| require dep }

# Framework lib goes to the front of the loadpath
$:.unshift('lib')
require 'waves'
require 'waves/runtime/mocks'

Waves::Runtime.instance = Waves::Runtime.new

Bacon::Context.module_eval do
  include Waves::Mocks
  alias_method :specification, :describe
  alias_method :feature, :it
end
