class Api::V1::PasswordResetController < ApplicationController
include TokenHelper
  skip_before_action :authenticate, only: [:update, :create]

  def create
    @user = User.find_by(email: params[:reset][:email])

    if @user
      token = encode_reset_token({id: @user.id})
      @user.update(reset_token: token)
      UserMailer.password_reset_email(@user, token).deliver_now
      render json: {message: 'Password reset email sent successfully'}, status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def update
    token = params[:token]
    decoded_token = decode_reset_token(token)
    @user = User.find(decoded_token['id'])

    if @user.reset_token === token && Time.now < Time.parse(decoded_token['expiry'])
      @user.update(password: params[:reset][:password], password_confirmation: params[:reset][:password_confirmation], reset_token: nil, token: nil)
      render json: { message: "Password changed successfully for #{@user.email}" }, status: :ok
    else
      render json: { error: 'Invalid or expired reset token' }, status: :unprocessable_entity
    end
  end

  private

  def password_reset_params
    params.require(:reset).permit(:email, :password)
  end

end
