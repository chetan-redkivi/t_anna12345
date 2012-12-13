class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter
    data = request.env["omniauth.auth"]
    @email = request.env["omniauth.auth"].info.nickname
    @secret = request.env["omniauth.auth"]['credentials']['secret']
    @token = request.env["omniauth.auth"]['credentials']['token']
    @secret = request.env["omniauth.auth"]['credentials']['secret']

    #	render :text => request.env["omniauth.auth"].inspect and return false


    user = User.find_by_email(@email)
    if user.present?
      user
      update_twitter_authentication(user)
    else # Create a user with a stub password.
      user = create_new_user()
      create_twitter_authentication(data, user)

    end

    if user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "#{params[:action]}".capitalize
      sign_in_and_redirect user, :event => :authentication
    else
      session["devise.#{params[:action]}_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end

  end

  def create_new_user
    user = User.new
    user.email = @email
    user.encrypted_password = Devise.friendly_token[0, 20]
    user.save(:validate => false)
    user
  end

  def update_twitter_authentication(user)
    twitter_authentication = TwitterAuthentication.find_by_user_id(user.id)
    if twitter_authentication.present?
      twitter_authentication.update_attributes({'token' => request.env["omniauth.auth"].credentials.token,'secret' => request.env["omniauth.auth"].credentials.secret})
    else
      create_twitter_authentication(request.env["omniauth.auth"],user)
    end
  end

  private

  def create_twitter_authentication(data, user)
    auth = TwitterAuthentication.find_by_uid_and_user_id(data.uid, @email)
    if auth.nil?
      twitter_authentication = TwitterAuthentication.new
      twitter_authentication.uid = request.env["omniauth.auth"].uid
      twitter_authentication.token = request.env["omniauth.auth"].credentials.token
      twitter_authentication.secret = request.env["omniauth.auth"].credentials.secret
      twitter_authentication.user_id = user.id
      twitter_authentication.save
    end
  end
end
