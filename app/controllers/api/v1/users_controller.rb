class Api::V1::UsersController < ApplicationController
    include ActionController::HttpAuthentication::Basic::ControllerMethods
    http_basic_authenticate_with name: "user", password: "pass", only: [:index, :show_score]

    # GET /users
    def index
        @users = User.all
        render json: @users
    end

    # GET /user/:id
    def show
        @user = User.find(params[:id])
        render json: @user
    end

    # GET /user/:id/score
    def show_score
        @user = User.find(params[:id])
        render json: @user.score
    end

    # POST /users
    def create
        @user = User.new(user_params)
        if @user.save
            render json: @user
        else
            render error: { error: 'Unable to create User' }, status: 400
        end
    end

    # DELETE /users/:id
    def destroy
        @user = User.find(params[:id])
        if @user
            @user.destroy
            render json: { message: 'User destroyed' }, status: 200
        else
            render json: { error: 'Could not destroy user' }, status: 400
        end
    end

    private

    def user_params
        params.require(:user).permit(:name)
    end
end
