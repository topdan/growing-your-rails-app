class UsersController < ApplicationController

  # basic case doesn't need a service
  def create
    @user = User.new(user_params)

    if @user.save
      UsersMailer.welcome(@user).deliver_later
      redirect_to root_path, notice: t('users.create.success')

    else
      flash[:alert] = t('users.create.failure')
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

end
