class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception     # エラーを投げる
  before_action :configure_permitted_parameters, if: :devise_controller? # sign_upのパラメータ追加
  prepend_before_action :set_headers

def set_headers
  response.headers['Cache-Control'] = 'no-store'
  response.headers['Pragma'] = 'no-cache'
end

    # def after_sign_up_path_for(resource)
    #      users_show_path
    # end

# ログイン後のリダイレクト先
    def after_sign_in_path_for(resource)
      if current_user.customer_id.nil?
          "https://otask.herokuapp.com/users/show"
      else
          "https://otask.herokuapp.com/users"
      end
    end

# ログアウト後のリダイレクト先
    def after_sign_out_path_for(resource)
        new_user_registration_path
    end


  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:company_name, :president_name, :address, :postal_code, :phone_number, :fax_number])
      devise_parameter_sanitizer.permit(:account_update, keys: [:company_name, :president_name, :address, :postal_code, :phone_number, :fax_number])
    end

  # ログインしていなければログインページヘリダイレクト
    def sign_in_required
        redirect_to new_user_session_url unless user_signed_in?
    end

end
