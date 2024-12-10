class ApplicationController < ActionController::API
    include JsonWebToken

    before_action :authenticate_request
    before_action :set_locale

    private
    # def authenticate_request
    #     header = request.headers["Authorization"]
    #     header = header.split(" ").last if header
    #     decoded = jwt_decode(header)
    #     @current_user = User.find(decoded[:user_id])
    # end

    def authenticate_request
        header = request.headers["Authorization"]
        
        # If no header or invalid token format
        if header.nil? || !header.start_with?('Bearer ')
          render json: { error: 'Unauthorized' }, status: :unauthorized
          return
        end
    
        begin
          # Remove 'Bearer ' prefix and decode
          token = header.split(" ").last
          decoded = jwt_decode(token)
          @current_user = User.find(decoded[:user_id])
        rescue
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
    end

    def set_locale
        I18n.locale = extract_locale_from_user || I18n.default_locale
    end
    
    def extract_locale_from_user
        user_language = @user&.language.presence
       
        case user_language
        when "english" then :en
        when "arabic" then :ar
        when "spanish" then :es
        when "hindi" then :hi
        when "french" then :fr
        else I18n.default_locale
        end
    end
end
