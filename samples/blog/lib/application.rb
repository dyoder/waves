require 'layers/orm/sequel'
module Blog
  include Waves::Foundations::Default
  include Waves::Layers::ORM::Sequel
end
