module Waves
  # Much love to Facets (more specifically English) for this module
  # http://english.rubyforge.org/
  # changed slightly in the hopes of one day implementing a different set
  # of rules for different languages
  # NOTE: this is NOT implemented yet.
  # plural and singular work directly with the English class
  module Inflect # :nodoc:
    module InflectorMethods
      
      # Define a general exception.
      def word(singular, plural=nil)
        plural = singular unless plural
        singular_word(singular, plural)
        plural_word(singular, plural)
      end

      # Define a singularization exception.
      def singular_word(singular, plural)
        @singular_of ||= {}
        @singular_of[plural] = singular
      end

      # Define a pluralization exception.
      def plural_word(singular, plural)
        @plural_of ||= {}
        @plural_of[singular] = plural
      end

      # Define a general rule.
      def rule(singular, plural)
        singular_rule(singular, plural)
        plural_rule(singular, plural)
      end

      # Define a singularization rule.
      def singular_rule(singular, plural)
        (@singular_rules ||= []) << [singular, plural]
      end

      # Define a plurualization rule.
      def plural_rule(singular, plural)
        (@plural_rules ||= []) << [singular, plural]
      end

      # Read prepared singularization rules.
      def singularization_rules
        @singular_rules ||= []
        return @singularization_rules if @singularization_rules
        sorted = @singular_rules.sort_by{ |s, p| "#{p}".size }.reverse
        @singularization_rules = sorted.collect do |s, p|
          [ /#{p}$/, "#{s}" ]
        end
      end

      # Read prepared pluralization rules.
      def pluralization_rules
        @plural_rules ||= []
        return @pluralization_rules if @pluralization_rules
        sorted = @plural_rules.sort_by{ |s, p| "#{s}".size }.reverse
        @pluralization_rules = sorted.collect do |s, p|
          [ /#{s}$/, "#{p}" ]
        end
      end

      #
      def plural_of
        @plural_of ||= {}
      end

      #
      def singular_of
        @singular_of ||= {}
      end

      # Convert an English word from plural to singular.
      #
      #   "boys".singular      #=> boy
      #   "tomatoes".singular  #=> tomato
      #
      def singular(word)
        if result = singular_of[word]
          return result.dup
        end
        result = word.dup
        singularization_rules.each do |(match, replacement)|
          break if result.gsub!(match, replacement)
        end
        return result
      end

      # Convert an English word from singular to plurel.
      #
      #   "boy".plural     #=> boys
      #   "tomato".plural  #=> tomatoes
      #
      def plural(word)
        if result = plural_of[word]
          return result.dup
        end
        #return self.dup if /s$/ =~ self # ???
        result = word.dup
        pluralization_rules.each do |(match, replacement)|
          break if result.gsub!(match, replacement)
        end
        return result
      end
    end
  end
end
