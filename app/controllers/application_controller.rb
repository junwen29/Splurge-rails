class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  include Splurge::ApiHelper
  before_filter :authenticate_user_from_token!
  before_filter :skip_trackable


  rescue_from StandardError, :with => :standard_error
  rescue_from Exception, :with => :standard_error
  rescue_from ActiveRecord::ActiveRecordError, :with => :active_record_error
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  protected

  def skip_trackable
    request.env['devise.skip_trackable'] = true
  end

  private
  def authenticate_user_from_token!
    user_token = params[:auth_token].presence
    user       = user_token && User.find_by_authentication_token(user_token.to_s)

    if user
      # Notice we are passing store false, so the user is not
      # actually stored in the session and a token is needed
      # for every request. If you want the token to work as a
      # sign in token, you can simply remove store: false.
      sign_in user #, store: false
    end
  end

end
