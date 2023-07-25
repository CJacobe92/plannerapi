
require "token_helper"

module AuthHelper
  include TokenHelper
  def header(user)
    if user && user.authenticate('password')
      token = encode_token(
        id: user.id,
        email: user.email,
        valid: true
      )
      user.update(token: token)
      return "Bearer #{token}"
    end
  end
end
