class UsersController < ApplicationController

  before_filter :authenticate_user!

  def show
    @user = User.find(params[:id])
    @joined_teams
    @owned_teams
  end

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.update_attributes(user_params)
      redirect_to users_path
    else
      render :edit
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update

    @user = User.find(params[:id])

  if @user.update_attributes(user_params)
    redirect_to user_path
  else
    render :edit
  end #if block

  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, confirm: "are you sure you want to delete this user"
  end

  private

  def user_params
    # params.require(:user).permit(:name, :tag, :mission, :image, :email, :password, :password_confirmation)
    params.require(:user).permit(:name, :tag, :mission, :image)
  end
end
