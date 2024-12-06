require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }

  describe 'GET #index' do
    it 'returns a list of posts with pagination' do
    end
  end

  
end
