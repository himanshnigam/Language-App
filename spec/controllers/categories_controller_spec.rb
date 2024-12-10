require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_attributes) { attributes_for(:category) }
  let(:invalid_attributes) { { name: nil } }

  before do
    token = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
    request.headers['Authorization'] = "Bearer #{token}"
  end

  describe 'GET #index' do
    it 'returns a successful response with categories' do
      create_list(:category, 3)
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET #show' do
    let(:category) { create(:category) }

    it 'returns the specific category' do
      get :show, params: { id: category.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['name']).to eq(category.name)
    end
  end

  describe 'POST #create' do
    it 'creates a new category' do
      expect {
        post :create, params: { category: valid_attributes }
      }.to change(Category, :count).by(1)
      
      expect(response).to have_http_status(:created)
    end

    it 'does not create category with invalid attributes' do
      expect {
        post :create, params: { category: invalid_attributes }
      }.to_not change(Category, :count)
      
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT #update' do
    let(:category) { create(:category) }

    it 'updates the category' do
      put :update, params: { id: category.id, category: { name: 'Updated Name' } }
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['name']).to eq('Updated Name')
    end
  end

  describe 'DELETE #destroy' do
    let!(:category) { create(:category) }

    it 'deletes the category' do
      expect {
        delete :destroy, params: { id: category.id }
      }.to change(Category, :count).by(-1)
      
      expect(response).to have_http_status(:no_content)
    end
  end
end