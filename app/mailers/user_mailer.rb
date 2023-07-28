class UserMailer < ApplicationMailer
  def password_reset_email(user, token)
    @user = user
    @reset_url= "https://taskedcjacobe.netlify.app/api/v1/password_reset?token=#{token}"
    mail(to: @user.email, subject: 'Password Reset')
  end
end
