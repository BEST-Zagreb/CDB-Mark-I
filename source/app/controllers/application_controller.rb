class ApplicationController < ActionController::Base
  if RAILS_ENV == 'production'
    before_filter :authenticate
  end
  protect_from_forgery

  protected
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      # Real value removed for publication; set your own before running.
      username == "CHANGE_ME_USERNAME" && password == "CHANGE_ME_PASSWORD"
    end
  end
end

