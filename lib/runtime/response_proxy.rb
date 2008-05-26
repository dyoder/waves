module Waves

  # Mapping actions are evaluated in the context of a ResponseProxy.
  class ResponseProxy

    attr_reader :request

    include ResponseMixin

    def initialize(request)
      @request = request
    end

    def controller_actions ; @c_actions ||= %w( all find create update delete ) ; end
    def collection_views ; @v_actions ||= %w( list ) ; end
    def instance_views ; @v_actions ||= %w( show editor ) ; end

    # remaining question is how to determine whether we already have a plural 
    # method or singular method ... ?
    def action( name, args )
      resource, id = args; redirect_to = false ; output = ''
      controller = controllers[resource]; view = views[resource]
      name.to_s.split('_').each do |item|
        Waves::Logger.info "ResponseProxy: #{item}"
        if controller_actions.member?(item)
          data = case controller.method( item ).arity
          when 0 then controller.send( item )
          when 1 then controller.send( item, id )
          end
        elsif collection_views.member?( item )
          output = view.send( item, resource.intern => data )
        elsif instance_views.member?( item )
          output = view.send( item, resource.intern => data )
        elsif item == 'redirect'
          redirect_to = true
        elsif redirect_to
          redirect_to = mapping.named[item] if mapping.named[item]
        end
      end
      request.redirect( redirect_to.call( :resource => resource ) ) if redirect_to
      return output
    end

  end

end
