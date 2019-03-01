# frozen_string_literal: true

module IV
  module Plurk
    # Define class method for API class
    module DirectCallable
      # :nodoc:
      module ClassMethods
        def respond_to_missing?(name)
          super
        end

        def method_missing(name, *args, &block)
          if instance_methods.include?(name.to_sym)
            return new(Plurk.current).send(name, *args, &block)
          end

          super
        end
      end

      def self.included(klass)
        klass.extend ClassMethods
      end
    end
  end
end
