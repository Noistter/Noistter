class SessionsController < ApplicationController
  skip_before_filter :require_login
  
  def create
    session[:access_token] = request.env['omniauth.auth']['credentials']['token']
    session[:access_token_secret] = request.env['omniauth.auth']['credentials']['secret']
    redirect_to home_path, notice: "Signed in"
  end
  
  def show
    if session['access_token'] && session['access_token_secret']
      @user = client.user(include_entities: true)
      redirect_to home_path
    else
      redirect_to landpage_path
    end
  end

  def error
    flash[:error] = "Sign in with Twitter failed"
    redirect_to root_path
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "Signed out"
  end
end