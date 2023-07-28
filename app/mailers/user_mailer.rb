class UserMailer < ApplicationMailer
  def password_reset_email(user, token)
    @user = user
    # @frontend_url = Rails.application.credentials.dig(:frontend, :url)
    @reset_url= "http://localhost:5173/api/v1/password_reset?token=#{token}"
    mail(to: @user.email, subject: 'Password Reset')
  end
end
