require 'layers/orm/active_record'
module Blog
  include Waves::Foundations::Default
  include Waves::Layers::ORM::ActiveRecord
end
