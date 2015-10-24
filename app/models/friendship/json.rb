module Friendship::Json
  extend ActiveSupport::Concern

  included do

    def to_json(json, options = {})

      json.id     self.id
      user_json json
      friend_json json

      # json.set! :user do
      #     self.user.to_json (json)
      # end
      # json.set! :friend do
      #   self.friend.to_json(json)
      # end

      # json.updated_at updated_at
      # json.created_at created_at
    end

    def user_json(json)
      json.user do
        json.id self.user.id
        json.username self.user.username
        json.email self.user.email
      end
    end

    def friend_json(json)
      json.friend do
        json.id self.friend.id
        json.username self.friend.username
        json.email self.friend.email
      end
    end

  end
end