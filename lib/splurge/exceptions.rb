
module Splurge
  module Exceptions

    class SplurgeError < StandardError
      attr_accessor :status, :type, :httpcode
      def initialize(status, type, httpcode, message)
        super(message)
        self.status = status
        self.type   = type
        self.httpcode = httpcode
      end
    end

    class BadRequestError < SplurgeError
      def initialize(message = '')
        super(:bad_request, "Bad Request", 400, message)
      end
    end


  end
end