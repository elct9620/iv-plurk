# frozen_string_literal: true

require 'oj'

module IV
  module Plurk
    # The realtime API
    class Realtime
      include DirectCallable

      Channel = Struct.new(:channel, :server)

      def initialize(client = nil)
        @client = client || Plurk.current
      end

      def channel
        res = @client.get('Realtime/getUserChannel')
        json = Oj.load(res.body)
        Channel.new(
          channel: json['channel_name'],
          server: json['comet_server']
        )
      end
    end
  end
end
