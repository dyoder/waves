require 'rinda/ring'
require 'rinda/tuplespace'
module Waves
  module TupleSpace
    class Worker
      def initialize(worker)
        @worker = worker
      end

      def run
        begin
          @drb_server = DRb.start_service
          ring_server = Rinda::RingFinger.primary
          ts = ring_server.read([:name, :TupleSpace, nil, nil])[2]
          @ts = Rinda::TupleSpaceProxy.new ts
        rescue RuntimeError
          Waves::Logger.info "Waves manager didn't start. Manager commands won't be available!"
        end
        start_listening
      end

      def start_listening
        #Register self with tuple space.
        @ts.write([:worker, app_name, uri])
        #Start listening for commands
        loop do
          puts "started listening..."
          job = @ts.take([:command, app_name, uri, nil, nil])
          puts "Got job " + job.to_s
          command = job[3]
          @worker.send(command, job)
        end
      end

      def stop
        #unregister itself.
        @ts.write([:worker, app_name, uri, :unregister])
        @drb_server.stop_service
      end
      def uri
        @uri ||= "#{ @worker.host }:#{ @worker.port }"
      end

      def app_name
        @app_name ||= Waves.main.name.downcase
      end

    end
  end
end

