# frozen_string_literal: true

module IV
  module Plurk
    # The configure for iv-plurk
    class Credential
      attr_accessor :consumer_key, :consumer_secret,
                    :oauth_token, :oauth_secret

      # TODO: Support normal OAuth flow
      def initialize(
        consumer_key: nil, consumer_secret: nil,
        oauth_token: nil, oauth_secret: nil
      )
        @consumer_key = consumer_key || ENV['PLURK_CONSUMER_KEY']
        @consumer_secret = consumer_secret || ENV['PLURK_CONSUMER_SECRET']
        @oauth_token = oauth_token || ENV['PLURK_OAUTH_TOKEN']
        @oauth_secret = oauth_secret || ENV['PLURK_OAUTH_SECRET']
      end

      def satisfied?
        return false if @consumer_key.nil?
        return false if @consumer_secret.nil?
        return false if @oauth_token.nil?
        return false if @oauth_secret.nil?

        true
      end

      def hmac_key
        @hmac_key ||= "#{@consumer_secret}&#{@oauth_secret}"
      end
    end
  end
end
