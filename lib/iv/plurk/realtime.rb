# frozen_string_literal: true

require 'oj'

module IV
  module Plurk
    # The realtime API
    class Realtime
      COMET_RULE = /CometChannel\.scriptCallback\((.*)\)/.freeze

      include DirectCallable

      Channel = Struct.new(:channel, :server)

      def initialize(client = nil)
        @client = client || Plurk.current
      end

      def channel
        res = @client.get('Realtime/getUserChannel')
        json = Oj.load(res.body)
        Channel.new(
          json['channel_name'],
          json['comet_server']
        )
      end

      def subscribe(&_block)
        continue = true
        while continue
          res = Net::HTTP.get(URI(channel.server))
          continue = yield Oj.load(res[COMET_RULE, 1])
        end
      end
    end
  end
end
