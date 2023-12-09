# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  #protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:organization_id])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:organization_id])
  end


  #POST /resource
  def create
    build_resource(sign_up_params)
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        UserOrganization.create(user: resource, organization_id: 1)
        organization = Organization.find_by(organization_email: resource.email.split('@').last)
        if organization
          UserOrganization.create(user: resource, organization_id: organization.id)
          puts("New user_organization added")
        end
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  
end

