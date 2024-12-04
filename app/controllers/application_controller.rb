class ApplicationController < ActionController::API
    include JsonWebToken

    before_action :authenticate_request
    before_action :set_locale

    private
    def authenticate_request
        header = request.headers["Authorization"]
        header = header.split(" ").last if header
        decoded = jwt_decode(header)
        @current_user = User.find(decoded[:user_id])
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
