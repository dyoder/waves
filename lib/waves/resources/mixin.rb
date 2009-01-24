module Waves

  module Resources

    StatusCodes = {
      Waves::Dispatchers::NotFoundError => 404
    }


    module Mixin

      # Node in the URL resolution tree.
      #
      class Node
        attr_accessor :component, :definition
        attr_accessor :statics, :placeholders, :consumables, :maybes, :rest

        def initialize(component)
          @component    = component
          @statics      = []
          @placeholders = []
          @consumables  = []
          @maybes       = []
          @rest         = nil
          @definition   = nil
        end
      end

      attr_reader :request

      module ClassMethods

        def paths()
          unless @paths
            resource = self
            @paths = Class.new( superclass.respond_to?( :paths ) ? superclass.paths : Waves::Resources::Paths ) do
              @resource = resource
              def self.resource ; @resource ; end
            end
          else
            @paths
          end
        end

        def with(options)
          @options = options
          yield

        ensure
          @options = nil
        end

        def maps()
          @maps ||= Hash.new {|h, k| h[k] = Node.new :default }
        end


        # Define a mapping from a request to a resource.
        #
        # TODO: Once done building, flatten into an Array. Needs
        #       polymorphic support.
        #
        # TODO: Define backend methods rather than using block?
        #
        def on(methods, *pathspec, &block)
          case methods
          when Array
            # Nothing
          when true
            methods = [:get, :put, :post, :head]
          else
            methods = [methods]
          end

          methods.each {|m|
            tier = maps[m]

            pathspec.each_with_index {|component, i|
              case component
              when String, nil     # Static
                current = tier.statics.find {|n| n.component == component}

                unless current
                  current = Node.new component
                  tier.statics << current
                end
                tier = current

              when Symbol     # Placeholder
                # TODO: Could combine same label, but..point?
                current = Node.new component
                tier.placeholders << current
                tier = current

              when Range      # Some number of required and/or optional arguments
                # TODO: Forgetting to cap the range?

                required = component.begin

                required.times {
                  current = Node.new "<consumable>"
                  tier.consumables << current
                  tier = current
                }

                # Figure out if we can consume the rest.
                # TODO: Support other types of terminators?
                tail = pathspec[(i + 1)..-1].find {|c| c.kind_of? String }

                # Last required argument must have a definition
                tier.definition = block if !tail and required > 0

                if component.end == -1
                  raise "Rest of arguments must be last" unless i == (pathspec.size - 1)
                  current = Node.new "<rest>"
                  tier.rest = current
                  tier = current
                  break
                end

                # Then the optionals
                component.to_a[1..-1].each {
                  current = Node.new tail     # I.e. storing the one we are expecting
                  current.definition = block  # Need this if not getting all.
                  tier.maybes << current
                  tier = current
                }
                tier.definition = nil # UGH.

              when true
                component = 1..-1
                redo

              else
                raise "wtf?"
              end
            }

            raise "Mapping already defined!" if tier.definition
            tier.definition = block
          }
        end

      end


      # this is necessary because you can't define functors within a module because the functor attempts
      # to incorporate the superclass functor table into it's own
      def self.included( resource )

        resource.module_eval do

          include ResponseMixin
          extend ClassMethods

          def initialize(request)
            @request = request
            @maps = self.class.maps
          end

          def process
            begin
              before ; body = send( request.method ) ; after
            rescue Waves::Dispatchers::Redirect => e
              raise e
            rescue Exception => e
              response.status = ( StatusCodes[ e.class ] || 500 )
              ( body = handler( e ) ) rescue raise e
              Waves::Logger.warn e.to_s
              e.backtrace.each { |t| Waves::Logger.debug "    #{t}" }
            ensure
              always
            end
            return body
          end

          def to( resource )
            resource = case resource
            when Base
              resource
            when Symbol, String
              begin
                Waves.main::Resources[ resource ]
              rescue NameError => e
                Waves::Logger.debug e.to_s
                e.backtrace.each { |t| Waves::Logger.debug "    #{t}" }
                raise Waves::Dispatchers::NotFoundError
              end
              Waves.main::Resources[ resource ]
            end
            r = traits.waves.resource = resource.new( request )
            r.process
          end

          def redirect( path ) ; request.redirect( path ) ; end

          # override for resources that may have long-running requests. this helps servers
          # determine how to handle the request
          def deferred? ; false ; end


          def handler(error)
            raise error
          end

#          before {} ; after {} ; always {}
#          handler( Waves::Dispatchers::Redirect ) { |e| raise e }

#          %w( post get put delete head ).each do | method |
#            on( method ) { not_found }
#          end


          def extract_path(request)
            # TODO: Need to resqueeze here?
            request.traits.waves.path ||= request.path.squeeze("/").scan(/[^\/]+/).map { |e| Rack::Utils.unescape(e) }
          end


          # ...
          #
          # Occurs in a specific order.
          #
          # TODO: Needs a bunch of optimisation.
          #
          def descend(node, path)
            if path.empty?
              return node if node.definition
              return
            end

            component, rest = path.at(0), path[1..-1]

            # Static strings
            node.statics.each {|n|
              # This _must_ match (or not) since it is not variable
              return descend n, rest if n.component == component
            }

            # Maybes also anchor on static strings and they are nongreedy
            node.maybes.each {|n|
              # There may be multiple statics here
              if n.component == component
                found = descend n, rest
                found = descend n, path unless found
                return found if found
              end
            }

            # Placeholders
            node.placeholders.each {|n|
              # TODO: UGH. Try to avoid this check for all..
              found = descend n, rest

              if found
                captured[n.component] = component
                return found
              end
            }

            # Consumables
            node.consumables.each {|n|
              found = descend n, rest
              return found if found
            }

            # Deeper into the maybes that did not match here
            node.maybes.each {|n|
              found = descend n, rest
              return found if found
            }

            # All of the remaining path
            node.rest
          end

          #
          #
          def get(request)
            request.traits.waves.captured ||= {}  # TODO: Get rid of this.

            node =  descend @maps[:get], extract_path(request)

            raise "No node found" unless node
            block = node.definition or raise "No block in #{node.inspect} of #{@maps[:get].inspect} for #{request.path}"

            instance_eval &block
          end

        end
      end
    end

    class Base
      include Mixin
    end

  end


end
