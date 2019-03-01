# frozen_string_literal: true

module IV
  # The Plurk Client
  module Plurk
    class << self
      attr_accessor :current

      def use(client = Client.default, &_block)
        current = Plurk.current
        Plurk.current = client
        res = yield
        Plurk.current = current
        res
      end
    end
  end
end
