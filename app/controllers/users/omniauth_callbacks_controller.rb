class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model
    @user = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)
    auth = request.env["omniauth.auth"]
    @user.authentications.find_or_create_by_provider_and_uid_and_token(auth['provider'], auth['uid'], auth['credentials']['token'])
    if @user.persisted?
      
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = env["omniauth.auth"]
      redirect_to home_path
    end
  end
  
  def twitter
    #render :text => request.env["omniauth.auth"].to_yaml
    auth = request.env["omniauth.auth"]
    name_array = auth["user_info"]["name"].split(" ")
    nickname = auth["user_info"]["nickname"]
    first_name = name_array.first
    if (name_array.size > 1)
      last_name = name_array.last
    else
      last_name = ""
    end
    if (!User.exists?(:name => nickname))
      user = User.new(:first_name => first_name, :last_name => last_name, :name => nickname)
      user.save(false)
      flash[:notice] = "Signup with Twitter account successful.  Welcome to UsherBuddy!"
    else
      user = User.find_by_name(nickname)
      flash[:notice] = "Signed in succesfully."
    end
    sign_in_and_redirect user, :event => :authentication
    
    #current_user.authentications.find_or_create_by_provider_and_uid_and_token_and_secret(auth['provider'], auth['uid'], auth['credentials']['token'], auth['credentials']['secret'])

    #redirect_to home_path
  end
  
  def google
    # You need to implement the method below in your model
    @user = User.find_for_google_oauth(env["omniauth.auth"], current_user)

    #if @user.persisted?
    #  flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
    #  sign_in_and_redirect @user, :event => :authentication
    #else
    #  session["devise.google_data"] = env["omniauth.auth"]
    #  redirect_to new_user_registration_url
    #end
    redirect_to user_session_path
  end

end
