class AuthenticationController < ApplicationController
    skip_before_action :authenticate_request

    def signup
        @user = User.new(user_params)
        if @user.save
            token = jwt_encode(user_id: @user.id)
            UserMailer.welcome_email(@user).deliver_now
            render json: { user: @user, token: token }, status: :created
        else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def login
        @user = User.find_by_email(params[:user][:email])
        if @user&.authenticate(params[:user][:password])
            token = jwt_encode(user_id: @user.id)
            render json: { token: token }, status: :ok
        else
            render json: { error: 'unauthorized' }, status: :unauthorized
        end
    end    

    private

    def user_params
        params.require(:user).permit(:name, :username, :email, :password, :language)
    end
end
