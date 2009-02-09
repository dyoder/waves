require 'rinda/ring'
require 'rinda/tuplespace'
module Waves
  module TupleSpace
    class Manager
      class Broker
        def initialize(ts)
          @ts = ts
        end
        def unregister(tuple)
          puts('Unregistering....' + tuple.to_s )
          @ts.take(tuple, 0) rescue nil
        end
        def run
          loop do
            puts "trying to look for unregisters..."
            #Take unregister requests
            tuple = @ts.take([:worker, nil, nil, :unregister])
            unregister(tuple[0..2])
          end
        end
      end
      def initialize
      end
      def run
        server = DRb.start_service
        puts server
            require 'ruby-debug'; debugger
        Rinda::RingServer.new Rinda::TupleSpace.new
        ts = Rinda::TupleSpace.new
        server = DRb.start_service
        provider = Rinda::RingProvider.new :TupleSpace, ts, 'Tuple Space'
        provider.provide
        puts "Starting waves broker..."
        Thread.new{ Broker.new(ts).run }
        puts "Started waves manager.."
        DRb.thread.join
      end
      def allocate_job(command)
        DRb.start_service
        ring_server = Rinda::RingFinger.primary
        ts = ring_server.read([:name, :TupleSpace, nil, nil])[2]
        ts = Rinda::TupleSpaceProxy.new ts
        workers = ts.read_all([:worker, app_name, nil])
        puts 'Workers' + workers.to_s
        workers.each do |worker|
          #Format : :command, app_name, uri, command, id
          ts.write([:command, worker[1], worker[2], command, Time.now.to_i])
        end
      end
      def app_name
        #Hack to return app name.
        @app_name ||= Dir.pwd.split('/')[-1].downcase
      end

    end
  end
end

