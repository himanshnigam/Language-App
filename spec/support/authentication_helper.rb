# spec/support/authentication_helper.rb
# module AuthenticationHelper
#     include JsonWebToken  # This will allow access to jwt_encode
  
#     def sign_in(user)
#       token = jwt_encode(user_id: user.id)  # This should work now
#       request.headers["Authorization"] = "Bearer #{token}"
#     end
#   end
