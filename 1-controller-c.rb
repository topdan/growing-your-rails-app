class SessionsController < ApplicationController

  # Service allows the controller logic to be
  # a simple if-elsif statement.
  def create
    @signin = Sessions::SignIn.new(session_params)

    if @signin.locked_out?
      flash[:alert] = t('sessions.create.locked_out')
      redirect_to action: 'new'

    elsif @signin.invalid_credentials?
      flash.now[:alert] = t('session.create.invalid_credentials')
      render 'new'

    elsif @signin.needs_to_set_password?
      login(@signin.user)
      flash[:notice] = t('sessions.create.needs_to_set_password')
      redirect_to new_user_password_path

    else
      login(@signin.user)
      redirect_to root_path, notice: t('sessions.create.success')
    end
  end

  private

  def session_params
    params.require(:session).permit(:username, :password)
  end

  def login(user)
    # A production app would have more here
    session[:user_id] = user.id
  end

end
