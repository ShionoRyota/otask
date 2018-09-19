class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

    # def after_sign_up_path_for(resource)
    #      users_show_path
    # end

    def after_sign_in_path_for(resource)
         users_show_path
    end

    def after_sign_out_path_for(resource)
        new_user_registration_path
    end



  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:company_name, :president_name, :address])
      devise_parameter_sanitizer.permit(:account_update, keys: [:company_name, :president_name, :address])
    end

    def sign_in_required
        redirect_to new_user_session_url unless user_signed_in?
    end

end
