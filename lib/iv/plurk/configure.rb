# frozen_string_literal: true

require 'singleton'

module IV
  module Plurk
    # The configure for iv-plurk
    class Configure
      class << self
        def respond_to_missing?(name)
          instance.respond_to_missing?(name)
        end

        def method_missing(name, *args, &block)
          if instance.respond_to?(name)
            return instance.send(name, *args, &block)
          end

          super
        end
      end

      include Singleton

      attr_accessor :consumer_key, :consumer_secret,
                    :oauth_token, :oauth_secret

      def initialize
        @consumer_key = ENV['PLURK_CONSUMER_KEY']
        @consumer_secret = ENV['PLURK_CONSUMER_SECRET']
        @oauth_token = ENV['PLURK_OAUTH_TOKEN']
        @oauth_secret = ENV['PLURK_OAUTH_SECRET']
      end

      def satisfied?
        return false if @consumer_key.nil?
        return false if @consumer_secret.nil?
        return false if @oauth_token.nil?
        return false if @oauth_secret.nil?

        true
      end
    end
  end
end
