# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__), "..", "helpers")

require 'layers/orm/data_mapper'

module DMApplication
  include Waves::Foundations::Default
  include Waves::Layers::ORM::DataMapper
end

DMA = DMApplication
DMAMapping = DMA::Configurations::Mapping
DMApplication::Configurations::Default

module DMApplication
  module Configurations
    class Development < Default
      database :database => 'sqlite3::memory'
    end
  end
end



specification "DataMapper Associations" do

  before do
  end

  specify 'Add before and after filters that push a new repo' do
    filters = DMAMapping.send :filters
    filters[:after][0][0][:path].should == /.*/
    filters[:before][0][0][:path].should == /.*/
    before_size = ::DataMapper::Repository.context.size
    filters[:before][0][1].call
    after_size = ::DataMapper::Repository.context.size
    (after_size - before_size).should == 1
    filters[:after][0][1].call
    end_size = ::DataMapper::Repository.context.size
    (end_size - after_size).should == -1
  end
  
  specify 'It should initialize the database adapater' do
    DMA.database.class.should.not == nil
    DMA.database.class.should == ::DataMapper::Adapters::Sqlite3Adapter
  end

  specify 'It should load models' do
    # pending
  end

end
