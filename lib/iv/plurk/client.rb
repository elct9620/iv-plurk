# frozen_string_literal: true

module IV
  module Plurk
    # The Abstract Plurk client
    class Client
      class << self
        def default
          @default ||= new(Credential.new)
        end
      end

      ENDPOINT = 'https://www.plurk.com/APP/%<path>s'

      def initialize(credential)
        @credential = credential
      end

      def get(path, params = {})
        Request.new(
          @credential,
          'GET',
          URI(format(ENDPOINT, path: path)),
          params.merge(oauth_params)
        ).start!
      end

      # TODO: Support Other HTTP Request

      private

      def oauth_params
        {
          oauth_consumer_key: @credential.consumer_key,
          oauth_nonce: Random.rand(100_000).to_s,
          oauth_signature_method: 'HMAC-SHA1',
          oauth_timestamp: Time.now.to_i,
          oauth_token: @credential.oauth_token,
          oauth_version: '1.0'
        }
      end
    end
  end
end
