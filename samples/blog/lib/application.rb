module Blog
  include Waves::Foundations::Default
  include Layers::REST
  include Layers::ORM::Sequel
end
Waves << Blog
