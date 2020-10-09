# lib/json_web_token.rb

class JsonWebToken
    class << self
      def encode(payload, exp = 24.hours.from_now)
        payload[:exp] = exp.to_i
        JWT.encode(payload, 'wdh2wdh')
      end
   
      def decode(token)
        body = JWT.decode(token, 'wdh2wdh')[0]
        HashWithIndifferentAccess.new body
      rescue
        nil
      end
    end
   end