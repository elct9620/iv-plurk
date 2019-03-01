# frozen_string_literal: true

module IV
  module Plurk
    # The API Request wrapper
    class Request
      attr_reader :credential, :method, :uri, :params

      def initialize(credential, method, uri, params = {})
        @credential = credential
        @method = method.to_s.upcase
        @uri = uri
        @params = params
      end

      def signature
        @signature ||= Signature.sign!(self)
      end

      def start!
        Net::HTTP.start(uri.host, uri.port, use_ssl: ssl?) do |http|
          http.request(signed_request)
        end
      end

      def ssl?
        uri.scheme == 'https'
      end

      private

      def signed_request
        @signed_request ||= http_class.new(signed_uri)
      end

      def signed_uri
        uri = @uri.clone
        uri.query =
          URI.encode_www_form(@params.merge(oauth_signature: signature))
        uri
      end

      def http_class
        @http_class ||=
          Net::HTTP.const_get(
            @method.downcase.sub(/^./, &:upcase)
          )
      end
    end
  end
end
