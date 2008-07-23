# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__), "..", "helpers")

begin
  require 'layers/orm/data_mapper'
  require 'flexmock'

  module DMApplication
    include Waves::Foundations::Default
    include Waves::Layers::ORM::DataMapper
  end

  DMA = DMApplication
  DMAMapping = DMA::Configurations::Mapping
  DMApplication::Configurations::Default

  module DMA ; include Waves::Foundations::Simple ; end
  Waves << DMA
  Waves::Console.load( :mode => :development )

  module DMApplication
    module Configurations
      class Development < Default
        database :database => 'sqlite3::memory'
      end
    end
  end

  module Bacon
    class Context
      include FlexMock::ArgumentTypes
      include FlexMock::MockContainer
    end
  end

  describe "DataMapper Associations" do
  
    before do
      @adapter = FlexMock::DefaultFrameworkAdapter.new
    end

    after do
      flexmock_verify
    end

    it 'should add before and after filters that push a new repo' do
      filters = DMAMapping.send :filters
      filters.should.not == nil
      filters[:before][0][0][:path].should == true
      filters[:always][0][0][:path].should == true
      before_size = ::DataMapper::Repository.context.size
      filters[:before][0][1].call
      after_size = ::DataMapper::Repository.context.size
      (after_size - before_size).should == 1
      filters[:always][0][1].call
      end_size = ::DataMapper::Repository.context.size
      (end_size - after_size).should == -1
    end

    it 'should add before and after filters that push a new repo with flexmock' do
      mock_context = flexmock("context")
      flexmock(::DataMapper::Repository, :context => mock_context)
      mock_context.should_receive(:push).once
      mock_context.should_receive(:pop).once

      filters = DMAMapping.send :filters
      filters[:before][0][1].call
      filters[:always][0][1].call
    end
  
    it 'should initialize the database adapater' do
      DMA.database.class.should.not == nil
      DMA.database.class.should == ::DataMapper::Adapters::Sqlite3Adapter
    end

    it 'It should load models' do
      # pending
    end

  end
rescue LoadError => e
  describe "DataMapper Associations" do
    it 'should be able to load dm-core' do
      puts "\nDatamapper associations specs not run! Could not load dm-core: #{e}\n"
    end
  end
end
