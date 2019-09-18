module Request
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end

  module RequestHelpers
    def token_generator(user_id)
      JsonWebToken.encode(user_id: user_id)
    end

    def expired_token_generator(user_id)
      JsonWebToken.encode({ user_id: user_id }, (Time.now.to_i - 10))
    end

    def valid_headers
      {
        "Authorization" => token_generator(user.id),
        "Content-Type" => "application/json"
      }
    end

    def invalid_headers
      {
        "Authorization" => nil,
        "Content-Type" => "application/json"
      }
    end
  end
end