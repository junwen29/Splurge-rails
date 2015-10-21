module User::Json
  extend ActiveSupport::Concern

  included do
    def to_auth_json(json, options = {})
      to_json(json, options)
      json.auth_token       authentication_token
    end

    def to_json(json, options = {})
      json.id id
      json.username   username
      json.email email

      json.updated_at updated_at
      json.created_at created_at
    end

    #call by android friends activity
    def to_json_friends(json, options ={})
      to_json(json, options)
      friends_json json
    end

    # convert self.friends to json
    def friends_json(json)
      json.array! self.friends do |friend|
        friend.to_json json
      end
    end

  end
end
