# frozen_string_literal: true

require 'base64'
require 'openssl'
require 'cgi'

module IV
  module Plurk
    # Signature the request
    class Signature
      class << self
        def sign!(request, params)
          new(request, params).sign!
        end
      end

      def initialize(request, params = nil)
        @request = request
        @params = params || params_from_request
      end

      def sign!
        return if signed?

        @request.uri.query =
          URI.encode_www_form(
            @params.merge(oauth_signature: signature)
          )
        @request
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
              'sha1', Configure.hmac_key, base
            )
          )
      end

      private

      def escaped_endpoint
        @escaped_endpoint ||=
          CGI.escape(
            "#{@request.uri.scheme}://" \
            "#{@request.uri.host}" \
            "#{@request.uri.path}"
          )
      end

      def escaped_query
        @escaped_query ||=
          CGI.escape(
            URI.encode_www_form(@params)
          )
      end

      def params_from_request
        URI.decode_www_form(@request.uri.query || '').to_h
      end
    end
  end
end
