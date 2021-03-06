class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def all
    user = User.from_omniauth(env['omniauth.auth'], current_user)
    user.update_attributes(email: "#{user.name}_twitter@email.com") if env['omniauth.auth']['provider'] == "twitter"
    if user.persisted?
      sign_in user
      flash[:notice] = t('devise.omniauth_callbacks.success', :kind => User::SOCIALS[params[:action].to_sym])
      redirect_to root_path
      # if user.sign_in_count == 1
      #   redirect_to first_login_path
      # else
      # end
    else
      session['devise.user_attributes'] = user.attributes
      redirect_to new_user_registration_url
    end
  end

  User::SOCIALS.each do |k, _|
    alias_method k, :all
  end
end