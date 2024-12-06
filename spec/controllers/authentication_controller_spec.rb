require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  describe 'POST #signup' do
    context 'when valid details are provided' do
      let(:user_attributes) { attributes_for(:user) }

      it 'creates a new user and returns a token' do
        post :signup, params: { user: user_attributes }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to have_key('token')
        expect(JSON.parse(response.body)['user']['email']).to eq(user_attributes[:email])
      end

      it 'sends a welcome email' do
        post :signup, params: { user: user_attributes }

        expect(ActionMailer::Base.deliveries.count).to eq(1)
        expect(ActionMailer::Base.deliveries.first.to[0]).to eq(user_attributes[:email])
      end
    end

    context 'when invalid details are provided' do
      let(:invalid_user_attributes) { { name: '', email: '', password: '', username: '', language: '' } }

      it 'does not create a user and returns errors' do
        post :signup, params: { user: invalid_user_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('errors')
      end

      it 'does not send a welcome email' do
        post :signup, params: { user: invalid_user_attributes }

        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe 'POST #login' do
    let(:user) { create(:user, password: 'password123') }

    context 'when valid credentials are provided' do
      it 'logs in the user and returns a token' do
        post :login, params: { user: { email: user.email, password: 'password123' } }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context 'when invalid credentials are provided' do
      it 'returns an unauthorized error for wrong password' do
        post :login, params: { user: { email: user.email, password: 'wrong_password' } }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to have_key('error')
      end

      it 'returns an unauthorized error for non-existent email' do
        post :login, params: { user: { email: 'nonexistent@example.com', password: 'password123' } }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end
  end
end
