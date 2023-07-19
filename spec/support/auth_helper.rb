
require "token_helper"

module AuthHelper
  include TokenHelper
  def header(user)
    if user && user.authenticate('password')
      token = encode_token(
        id: user.id,
        firstname: user.firstname,
        lastname: user.lastname,
        email: user.email,
        valid: true
      )
      user.update(token: token)
      return "Bearer #{token}"
    end
  end
end
