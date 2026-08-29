class UsersController < ApplicationController
  layout "container"
  allow_unauthenticated_access only: %i[ new create show ]
  def index
    @users = User.all
  end
  def show
    @user = User.find(params[:id])
  end
  def destroy
    @user = User.find(params[:id])
  end
  def update
    @user = User.find(params[:id])
  end
  def create
    @user = User.new
    @user.email_address = params[:email_address]
    @user.password = params[:password]
    @user.password_confirmation = params[:password_validation]
    @user.username = "anonymous_" + SecureRandom.uuid
    if @user.save
      redirect_to "/session/new"
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end
  def new
    if authenticated?
      redirect_to "/"
    end
  end
end
