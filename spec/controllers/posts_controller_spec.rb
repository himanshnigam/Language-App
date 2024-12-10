require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:valid_attributes) { attributes_for(:post, category_id: category.id) }
  let(:invalid_attributes) { { title: '', body: '', category_id: nil } }
  let(:default_items) { 10 }

  before do
    token = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
    request.headers['Authorization'] = "Bearer #{token}"

    # stub_const('Pagy::DEFAULT', Pagy::DEFAULT.merge(items: default_items))
  end

  describe 'GET #index' do
    it 'returns paginated posts with metadata' do
      create_list(:post, 5, user: user, category: category) 
      get :index
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json_response).to have_key('pagination')
      expect(json_response).to have_key('posts')
      # expect(json_response['posts'].size).to be <= default_items
    end
  end

  describe 'POST #create' do
    it 'creates a new post with valid attributes' do
      expect {
        post :create, params: { post: valid_attributes }
      }.to change(Post, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it 'does not create a post with invalid attributes' do
      expect {
        post :create, params: { post: invalid_attributes }
      }.to_not change(Post, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET #show' do
    it 'returns the specific post' do
      post = create(:post, user: user, category: category)
      get :show, params: { id: post.id }
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json_response['title']).to eq(post.title)
      expect(json_response['body']).to eq(post.body)
    end
  end

  describe 'PUT #update' do
    it 'updates the post with valid attributes' do
      post = create(:post, user: user, category: category)
      updated_title = 'Updated Title'

      put :update, params: { id: post.id, post: { title: updated_title } }
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json_response['title']).to eq(updated_title)
    end

    it 'does not update the post with invalid attributes' do
      post = create(:post, user: user, category: category)

      put :update, params: { id: post.id, post: { title: '' } }
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response).to have_key('errors')
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the post' do
      post = create(:post, user: user, category: category)

      expect {
        delete :destroy, params: { id: post.id }
      }.to change(Post, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
