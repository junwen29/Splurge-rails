module User::Json
  extend ActiveSupport::Concern

  included do
    def to_auth_json(json, options = {})
      to_json(json, options)
      json.auth_token       authentication_token
    end

  end

  def to_json(json, options = {})
    json.id id
    json.username   username
    json.email email

    json.updated_at updated_at
    json.created_at created_at
  end

end