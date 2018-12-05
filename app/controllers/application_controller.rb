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
        new_user_session_path
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

# チェックボックス押すと、最終セッションからログイン状態を保持
before_filter :setup
def setup
  if session[:user_id]
    if session[:persistent] # 「ログイン状態を保持する」チェックボックスをチェックしたらtrueになるようにしておく
      session.instance_variable_get(:@dbman).instance_variable_get(:@cookie_options)['expires'] = 3.months.from_now # ここが要所！
      session[:persistent] = Time.now 
    end

    # Fetch the user record.
    @user = User.find_by_id(session[:user_id], :readonly => true)
  end
end


end
