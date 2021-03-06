class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :toggle_lock]
  before_action :ensure_that_admin, only: [:toggle_lock]
  before_action :ensure_that_signed_in, except: [:index, :show]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def toggle_lock
    @user.update_attribute :blocked, (not @user.blocked)

    new_status = @user.blocked? ? "locked" : "unlocked"

    redirect_to @user, notice:"user #{new_status}"
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if user_params[:username].nil? and @user.update(user_params) and current_user == @user
      redirect_to @user, notice: 'User was successfully updated.'
    else
      format.html { render :edit }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if current_user == @user and @user.destroy
      session[:user_id] = nil
      redirect_to beers_path, notice: 'User was successfully destroyed.'
    else
      format.html { render :destroy }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
     params.require(:user).permit(:username, :password, :password_confirmation)
    end

    def ensure_that_admin
      redirect_to :back, notice:'you are not allowed to do that' unless current_user.admin
    end
end
