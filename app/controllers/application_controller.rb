class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  
  before_action :set_device_type
  before_action :require_login
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers
  #For all responses in this controller, return the CORS access control headers.
  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = 'http://faye-server-10.herokuapp.com/'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = 'http://faye-server-10.herokuapp.com/'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end
  # If this is a preflight OPTIONS request, then short-circuit the
  # request, return only the necessary headers and return an empty
  # text/plain.
  def cors_preflight_check
    if request.method == :options
      headers['Access-Control-Allow-Origin'] = 'http://faye-server-10.herokuapp.com/'
      headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
      headers['Access-Control-Request-Method'] = 'http://faye-server-10.herokuapp.com/'
      headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
      render :text => '', :content_type => 'text/plain'
    end
  end

  private

  def require_login
    user = current_user
    unless user
      flash[:error] = "You must be logged in to access this section"
      redirect_to root_path and return
    end
    if user
      returning = (Time.now.utc - user.updated_at.utc > 3.hours)
      if returning
        user.visit_count += 1
        user.updated_at = Time.now
        user.active = true
        user.save
      else
        user.update_attributes updated_at: Time.now, active: true
      end
    end
  end

  def set_device_type
    request.variant = :phone if browser.mobile?
  end

end
