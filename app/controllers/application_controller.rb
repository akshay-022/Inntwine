class ApplicationController < ActionController::Base
  layout :layout_by_resource

  protect_from_forgery with: :exception, except: :update_options

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_default_organization_id

  private

  def set_default_organization_id
    # Set default value only if session[:organization_id] is nil
    session[:organization_id] ||= 2
  end

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :username])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :username, :profile_image])
    end
end
