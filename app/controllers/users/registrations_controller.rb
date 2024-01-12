# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  #protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:organization_id, :position, :linkedin])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:organization_id])
  end



  #POST /resource
  def create
    build_resource(sign_up_params)

    session[:position] = params[:user][:position] # Store the position value in an instance variable
    session[:linkedin] = params[:user][:linkedin] # Store the linkedIn value in an instance variable
    session[:name] = params[:user][:name]
    session[:username] = params[:user][:username]
    session[:email] = params[:user][:email]

    unless resource.email.ends_with?('columbia.edu')
      # Set an error message and halt the registration process
      flash[:notice] = "Please use Columbia E-mail to sign up!"
      redirect_to new_registration_path(resource_name) and return
    end
    # Check if linkedIn is a valid LinkedIn URL
    unless valid_linkedin_url?(resource.linkedin)
      flash[:alert] = "Please enter a valid LinkedIn URL."
      redirect_to new_registration_path(resource_name) and return
      return
    end
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        UserOrganization.create(user: resource, organization_id: 1)
        #organization = Organization.find_by(organization_email: resource.email.split('@').last)
        organization = Organization.find_by(organization_email: "columbia.edu")
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

  def valid_linkedin_url?(url)
    # Define a regular expression pattern for a LinkedIn profile URL
    linkedin_pattern = %r{\A.*www\.linkedin\.com\/in\/[a-zA-Z0-9-]+.*\z}
    # Use the pattern to check if the URL matches
    !!(url =~ linkedin_pattern)
  end


  private

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :username, :current_password, :password_confirmation, :position, :bio, :linkedin)
  end

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :username, :current_password, :password_confirmation, :position, :bio, :linkedin)
  end

end

