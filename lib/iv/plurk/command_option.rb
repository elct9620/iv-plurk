# frozen_string_literal: true

require 'optparse'

module IV
  module Plurk
    # Webhook command line
    class CommandOption < OptionParser
      class << self
        def load
          new.parse!(ARGV)
        end
      end

      attr_accessor :consumer_key, :consumer_secret,
                    :oauth_token, :oauth_secret,
                    :webhook_url

      def initialize
        super

        self.banner = 'Illustrator Vision - Plurk Watcher'

        configure_consumer
        configure_token
        on('-w', '--webhook URL', :REQUIRED,
           'Webhook URL', method(:webhook_url=))
      end

      def parse!(args)
        super
        self
      end

      private

      def configure_consumer
        on('-k', '--consumer_key [KEY]',
           'Plurk Consumer Key', method(:consumer_key=))
        on('-s', '--consumer_secret [SECRET]',
           'Plurk Consumer Secret', method(:consumer_secret=))
      end

      def configure_token
        on('-t', '--token [TOKEN]',
           'Plurk OAuth token', method(:oauth_token=))
        on('-S', '--secret [SECRET]',
           'Plurk OAuth secret', method(:oauth_secret=))
      end
    end
  end
end
