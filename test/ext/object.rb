require "#{File.dirname(__FILE__)}/../helpers.rb"

describe "Object#cache_method_missing" do
  
  before do
    class A; end
  end
  
  after do
    Object.instance_eval { remove_const(:A) if const_defined?(:A) }
  end
  
  it "defines the missing method" do
    A.module_eval do
      def method_missing(name, *args)
        cache_method_missing name, "'hi'", *args
      end
    end
    A.new.bar
    A.new.should.respond_to :bar
  end
  
  it "passes along the args" do
    A.module_eval do
      def method_missing(name, *args, &block)
        cache_method_missing name, "args.join('-')", *args
      end
    end
    
    A.new.bar(1, 2, 3).should == "1-2-3"
  end
  
  it "passes along the block" do
    A.module_eval do
      def method_missing(name, *args, &block)
        cache_method_missing name, "block.call", *args, &block
      end
    end
    
    A.new.bar { 'bye' }.should == 'bye'
  end  
  
end

describe "Object#instance_exec" do
  
  before do
    @block = lambda { |guy| "Howdy, #{guy}!" }
  end
  
  it "works like instance_eval, but it takes args and gives them to the block" do
    instance_exec( "Steve", &@block ).should == "Howdy, Steve!"
  end
  
end