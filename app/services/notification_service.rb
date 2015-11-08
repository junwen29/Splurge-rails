class NotificationService

  module ClassMethods

    def send_notification_by_user(notification_id, tokens)
      gcm = GCM.new("AIzaSyDQ0Cf2C--M6vpZBsj_CQHfmKeqPC3-_sc")
      notification = Notification.find(notification_id)

      options = {
          data:
              {
                  message:   notification.message,
                  item_type: notification.item_type,
                  item_id:   notification.item_id.to_s,
                  item_name: notification.item_name.to_s
              }
      }
      response = gcm.send(tokens, options)
      return response

    end

  end

  class << self
    include ClassMethods
  end

end