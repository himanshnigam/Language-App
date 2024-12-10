# spec/support/authentication_helper.rb
# module AuthenticationHelper
#   def generate_jwt_token(user)
#     payload = { user_id: user.id, exp: 7.days.from_now.to_i }
#     JWT.encode(payload, Rails.application.secret_key_base)
#   end

#   def auth_headers(user)
#     token = generate_jwt_token(user)
#     { 'Authorization': "Bearer #{token}" }
#   end
# end