
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

    class FriendRequestExistsError < SplurgeError
      def initialize(message = "The user has already sent a similar friend request.")
        super(:existing_error, "Existing Error", 406, message)
      end
    end

    class FriendDoesNotExistsError < SplurgeError
      def initialize(message = "The user has requested a non-existing user")
        super(:existing_error, "Not Found", 404, message)
      end
    end

    class FriendRequestApproveError < SplurgeError
      def initialize(message = "Unable to Approve Friend")
        super(:bad_request, "Bad Request", 400, message)
      end
    end

    class FriendRequestRejectError < SplurgeError
      def initialize(message = "Unable to Reject Friend")
        super(:bad_request, "Bad Request", 400, message)
      end
    end

  end
end