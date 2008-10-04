require 'foundations/classic'
require 'layers/orm/sequel'
module Blog
  include Waves::Foundations::Classic
  include Waves::Layers::ORM::Sequel
end
