#Use a before_filter. Place the following in your application controller.

# application_controller.rb

#before_filter :require_login

#private

#  def require_login
#    unless current_user
#      redirect_to login_url
#    end
#  end

#The code above assumes you have defined a method current_user which returns the user record when the user is logged in.

#Then, in your login controller

#skip_before_filter :require_login

require 'json'
class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def sendtweet
    text=params[:tuit]
    client.update(text) unless text == nil
    respond_to do |format|
        format.html {  }
	      format.json { head :no_content }
	      format.js
    end
  end
  
  def favorite
    tweet_id=params[:tuit_id]
    client.favorite(tweet_id)  unless tweet_id == nil
    respond_to do |format|
        format.html {  }
	      format.json { head :no_content }
	      format.js
    end
  end
  
  def retweet
    tweet_id=params[:tuit_id]
    client.retweet(tweet_id)  unless tweet_id == nil
    respond_to do |format|
        format.html {  }
	      format.json { head :no_content }
	      format.js
    end
  end
  
  private
  
  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = 'DogpapbYNWdAf9dOvAgpTQ'
      config.consumer_secret = 'lTXxr4qiGsaO78XeW0ZlA4dKWQka5tuz9crI4Xxm7w4'
      config.oauth_token = session['access_token']
      config.oauth_token_secret = session['access_token_secret']
    end
  end
 
end