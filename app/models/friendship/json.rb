module Friendship::Json
  extend ActiveSupport::Concern

  included do

    def to_json(json, options = {})
      json.id         id
      json.username   username
      json.email      email

      json.updated_at updated_at
      json.created_at created_at
    end

  end
end