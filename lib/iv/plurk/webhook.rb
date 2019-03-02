# frozen_string_literal: true

module IV
  module Plurk
    # Send plurk data to target url
    class Webhook
      attr_reader :uri, :thread

      def initialize(url)
        @uri = URI(url)
        # TODO: Add Worker Support
        @thread = nil
        @mutex = Mutex.new

        @queue = Queue.new
        @stop = false

        Signal.trap(:INT) { stop! }
      end

      def enqueue(data)
        ensure_worker
        @queue << data
      end

      def ssl?
        @uri.scheme == 'https'
      end

      def stop!
        @stop = true
      end

      def start
        @stop = false
        ensure_worker
      end

      def ensure_worker
        return if @stop
        return unless @thread.nil?

        @mutex.synchronize do
          @thread = Thread.new do
            submit(@queue.shift) until @stop
            @thread = nil
          end
        end
      end

      private

      def submit(data)
        req = Net::HTTP::Post.new(uri)
        req.body = Oj.dump(data)
        Net::HTTP
          .start(@uri.host, @uri.port, use_ssl: ssl?) do |http|
          http.request(req)
        end
      end
    end
  end
end
