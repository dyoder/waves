module Waves
  module Helpers
    module AssetHelper
      # Returns an html image tag for the +source+. The +source+ can be a full
      # path or a file that exists in your public images directory. Note that 
      # specifying a filename without the extension is now deprecated in Rails.
      # You can add html attributes using the +options+. The +options+ supports
      # two additional keys for convienence and conformance:
      #
      # * <tt>:alt</tt>  - If no alt text is given, the file name part of the 
      #   +source+ is used (capitalized and without the extension)
      # * <tt>:size</tt> - Supplied as "{Width}x{Height}", so "30x45" becomes 
      #   width="30" and height="45". <tt>:size</tt> will be ignored if the
      #   value is not in the correct format.
      #
      #  image_tag("icon.png")  # =>
      #    <img src="/images/icon.png" alt="Icon" />
      #  image_tag("icon.png", :size => "16x10", :alt => "Edit Entry")  # =>
      #    <img src="/images/icon.png" width="16" height="10" alt="Edit Entry" />
      #  image_tag("/icons/icon.gif", :size => "16x16")  # =>
      #    <img src="/icons/icon.gif" width="16" height="16" alt="Icon" />
      def image_tag(source, options = {})
        options.symbolize_keys!
          
        options[:src] = image_path(source)
        options[:alt] ||= File.basename(options[:src], '.*').split('.').first.capitalize
  
        if options[:size]
          options[:width], options[:height] = options[:size].split("x") if options[:size] =~ %r{^\d+x\d+$}
          options.delete(:size)
        end

        tag("img", options)
      end

      # Computes the path to an image asset in the public images directory.
      # Full paths from the document root will be passed through.
      # Used internally by image_tag to build the image path. Passing
      # a filename without an extension is deprecated.
      #
      #   image_path("edit.png")  # => /images/edit.png
      #   image_path("icons/edit.png")  # => /images/icons/edit.png
      #   image_path("/icons/edit.png")  # => /icons/edit.png
      def image_path(source)
        compute_public_path(source, 'images', 'png')
      end

      private
        def compute_public_path(source, dir, ext)
          source = source.dup
          source << ".#{ext}" if File.extname(source).blank?
          unless source =~ %r{^[-a-z]+://}
            source = "/#{dir}/#{source}" unless source[0] == ?/
            asset_id = rails_asset_id(source)
            source << '?' + asset_id if defined?(RAILS_ROOT) && !asset_id.blank?
            # source = "#{ActionController::Base.asset_host}#{@controller.request.relative_url_root}#{source}"
          end
          source
        end
        
        def rails_asset_id(source)
          ENV["WAVES_ASSET_ID"] || File.mtime("public/#{source}").to_i.to_s rescue ""
        end

    end
  end
end
