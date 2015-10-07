class RegistrationsController < Devise::RegistrationsController

  include Splurge::ApiHelper

  respond_to :json

  def require_no_authentication
    session["warden.user.user.key"] = nil
    super
  end

  def create
    params[:user] = {}
    params[:user][:email]      = request.params[:email]
    params[:user][:password]   = request.params[:password]
    params[:user][:username]   = request.params[:username]

    devise_parameter_sanitizer.for(:sign_up) { |u|
      u.permit(:username, :email, :password)
    }
    build_resource(sign_up_params)

    # end
    resource = self.resource
    resource.username ||= params[:username]

    saved = nil
    begin
      saved = resource.save

        # you have to call save method after saving user
        # if params[:google_token]
        #   social.user_id = resource.id
        #   social.save
        # end

    rescue ActiveRecord::RecordNotUnique
      saved = false
      resource.errors.add(:email, "has already been taken")
      # even if username is not unique, the flow doesn't come to this part
    end

    if saved
      if resource.active_for_authentication?
        sign_in(resource_name, resource)
      else #not active
        expire_session_data_after_sign_in!
      end

      render_jbuilder do |json|
        resource.to_auth_json(json)
      end

      # email for registrations has already existed, using the old user account to sign in
    elsif email_errors = resource.errors.messages[:email] and
        email_errors.include? "has already been taken" and
        resource = User.find_by_email(resource.email) and
        resource and
        resource.active_for_authentication? and
        resource.valid_password?(params[:password])

      sign_in resource_name, resource, :bypass => true
      render_jbuilder do |json|
        resource.to_auth_json(json)
      end

    else
      clean_up_passwords(resource)
      message = resource ? combine_messages(resource.errors.messages) : 'bad request error...'
      raise BadRequestError.new message
    end

  end

end