module Waves
  
  module Resources
    
    class NoMatchingResourceError < RuntimeError
      def initialize( request )
        super( request.path )
      end
    end
    
    class Selector
      
      #
      # TODO: Path generation stuff has been taken out until we work out the right design.
      #
      
      include Functor::Method
      
      def initialize ; @rules = [] ; end
      functor( :direct, Symbol ) { | resource | direct( :to => resource ) }
      functor( :direct, Array ) { | path | direct( :path => path ) }
      functor( :direct, Array, Hash ) { | path, options | options[ :path ] = path ; direct( options ) }
      functor( :direct, Hash ) { | options | @rules << resolver(  options ) }
      
      def resolver( options )
        matcher = Waves::Matchers::Request.new( options )
        lambda do | request |

          # first check to see if the request matches
          if matcher.call( request )
            
            # okay, it does. did they give us a resource explicitly?
            resource = if options[:to ]
              
              # yes, okay, just resolve that resource
              resolve( options[:to] )
            else
              
              # nope, try to get it from the path
              if r = request.traits.waves.captured[:resource]
                resolve( r )
              elsif r = request.traits.waves.captured[:resources]
                resolve( r.to_s.singular )
              else
                
                # they neither told us what it was, nor was it in the path ...
                raise NoMatchingResourceError.new( request )
              end
            end
            
            # next, we need to check for a delegator
            resource = if options[ :through ]
              
              # okay, create the the delegate and make that the resource
              resolve( options[ :through ] ).new( resource.new( request ), request )
            else
              
              # no delegator, just instantiate the resource
              resource.new( request )
            end
            
            # finally, we have a bit of bookkeeping to do to save the match
            save = request.traits.waves
            save.rest = save.captured[:rest]
            save.resource = resource
            save.captured.delete(:rest)
            save.captured.delete(:resource)
            save.captured.delete(:resources)
            return resource
            
          end
        end
      end
      
      def resolve( token )
        case token
        when Symbol, String then Waves.main::Resources[ token ]
        when Class then token
        end
      end
      
      def []( request ) ; call( request ); end
      
      # given a request, find the right resource
      def call( request )
        @rules.each do | rule | 
          resource = rule.call( request )
          return resource if resource
        end
        raise NoMatchingResourceError.new( request )
      end
            
      
    end
      
  end

end
