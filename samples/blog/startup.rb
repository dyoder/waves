require 'foundations/classic'
require 'layers/orm/providers/sequel'
require 'layers/renderers/markaby'
module Blog
  include Waves::Foundations::Classic
  include Waves::Layers::ORM::Sequel
  include Waves::Renderers::Markaby
end
