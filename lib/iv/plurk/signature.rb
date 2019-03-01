# frozen_string_literal: true

require 'base64'
require 'openssl'
require 'cgi'

module IV
  module Plurk
    # Signature the request
    class Signature
      class << self
        def sign!(request)
          new(request).sign!
        end
      end

      def initialize(request)
        @request = request
      end

      def sign!
        signature
      end

      def signed?
        @request.uri.query&.include?('oauth_signature')
      end

      def base
        @base ||= "#{@request.method}&" \
                  "#{escaped_endpoint}&" \
                  "#{escaped_query}"
      end

      def signature
        @signature ||=
          Base64.encode64(
            OpenSSL::HMAC.digest(
              'sha1', @request.credential.hmac_key, base
            )
          ).chomp
      end

      private

      def escaped_endpoint
        @escaped_endpoint ||=
          CGI.escape(@request.uri.to_s)
      end

      def escaped_query
        @escaped_query ||=
          CGI.escape(
            URI.encode_www_form(@request.params)
          )
      end
    end
  end
end
