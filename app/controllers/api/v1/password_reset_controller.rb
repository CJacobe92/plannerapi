class Api::V1::PasswordResetController < ApplicationController
include TokenHelper


  def create
    user = User.find_by(email: params[:user][:email])

    if user
      token = encode_reset_token({id: user.id, email: user.email})
      user.update(reset_token_expiry: (Time.now + 1.hour).iso8601)
      UserMailer.password_reset_email(user, token).deliver_later
      render json: {message: 'Password reset email sent successfully'}, status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def update
    user = User.find_by(reset_token: params[:token])

    if user && user.reset_token_expiry >= Time.now
      user.update(password: params[:password], reset_token: nil, reset_token_expiry: nil)
      render json: { message: 'Password reset successful' }, status: :ok
    else
      render json: { error: 'Invalid or expired reset token' }, status: :bad_request
    end
  end

  private

  def password_reset_params
    params.require(:user).permit(:email)
  end
end
