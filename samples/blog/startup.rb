require 'waves/foundations/classic'
require 'waves/layers/orm/providers/sequel'
require 'waves/layers/renderers/markaby'

module Blog
  include Waves::Foundations::Classic
  include Waves::Layers::ORM::Sequel
  include Waves::Renderers::Markaby
end
