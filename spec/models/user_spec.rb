require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations for User model' do
    let(:user) { build(:user) }
    let(:duplicate_user) { build(:user, username: user.username, email: user.email) }

    it 'is valid with all attributes present' do
      expect(user).to be_valid
    end

    it 'is invalid without an email' do
      user.email = nil
      expect(user).to_not be_valid
    end

    it 'is invalid without a password' do
      user.password = nil
      expect(user).to_not be_valid
    end

    it 'is invalid without a username' do
      user.username = nil
      expect(user).to_not be_valid
    end

    it 'is invalid without a language' do
      user.language = nil
      expect(user).to_not be_valid
    end

    it 'is invalid with a duplicate username' do
      user.save
      expect(duplicate_user).to_not be_valid
    end

    it 'is invalid with a duplicate email' do
      user.save
      duplicate_user.username = 'uniqueusername'
      expect(duplicate_user).to_not be_valid
      expect(duplicate_user.errors[:email]).to include('has already been taken')
    end
    
  end

  context 'associations for User model' do
    let(:user) { create(:user) }
    let(:post1) { create(:post, user: user) }
    let(:post2) { create(:post, user: user) }

    it 'has many posts' do
      expect(user.posts).to include(post1, post2)
    end
  
    it 'deletes associated posts when the user is deleted' do
      expect(Post.count).to eq(0)
    end
  end

  context 'language enum validations' do
    let(:user) { build(:user) }

    it 'has valid language enums' do
      expect(User.languages.keys).to include(*%w[english arabic spanish hindi french])
    end

    it 'is invalid with an undefined language' do
      expect { user.language = 'invalid_language' }.to raise_error(ArgumentError)
    end
  end
end
