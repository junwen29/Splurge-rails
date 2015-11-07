
class DeviceService

  module ClassMethods

    def tokens_by_user(user_id)
      tokens = []
      user = User.find(user_id)

      devices = user.devices
      devices.each { |device|
        tokens << device.token
      }

      return tokens
    end
  end

  class << self
    include ClassMethods
  end
end