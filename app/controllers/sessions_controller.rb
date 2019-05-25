class SessionsController < ApplicationController
  before_action :require_user, only: [:destory]

  def new; end

  def create
    user = User.find_by username: params[:username]

    if user && user.authenticate(params[:password])
      if user.two_factor_auth?
        session[:two_factor] = true
        user.generate_pin!
        #user.send_pin_to_twilio
        redirect_to pin_path
      else
        login_user!(user)
      end
    else
      flash.now[:error] = 'There is something wrong with your username or password'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = 'You are now logged out.'
    redirect_to root_path
  end

  def pin
    access_denied if session[:two_factor].nil?

    if request.post?
      user = User.find_by pin: params['pin']

      if user
        session[:two_factor] = nil
        user.remove_pin!
        login_user!(user)
      else
        flash[:error] = 'Sorry something is wrong with your pin number'
        redirect_to pin_path
      end
    end
  end

  private

  def login_user!(user)
    flash[:notice] = "Welcome, you've logged in."
    session[:user_id] = user.id
    redirect_to root_path
  end
end
