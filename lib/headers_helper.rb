module HeadersHelper
  def response_headers(token)
    response.headers['X-Request-ID'] = SecureRandom.uuid
    response.headers['Authorization'] = "Bearer #{token}"
    response.headers['Client'] = 'plannerapi'
  end
end
