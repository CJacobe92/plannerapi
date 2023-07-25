module HeadersHelper
  def response_headers(user, token)
    response.headers['Uid'] = user.id
    response.headers['X-Request-ID'] = SecureRandom.uuid
    response.headers['Authorization'] = "Bearer #{token}"
    response.headers['Client'] = 'plannerapi'
  end
end
