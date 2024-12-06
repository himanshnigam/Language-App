require 'rails_helper'

RSpec.describe Post, type: :model do
  context 'validations for Post model' do
    let(:post) { build(:post) }

    it 'is valid with all attributes present' do
      expect(post).to be_valid
    end

    it 'is invalid without a title' do
      post.title = nil
      expect(post).to_not be_valid
      expect(post.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without a body' do
      post.body = nil
      expect(post).to_not be_valid
      expect(post.errors[:body]).to include("can't be blank")
    end
  end

  context 'associations for Post model' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to a category' do
      association = described_class.reflect_on_association(:category)
      expect(association.macro).to eq(:belongs_to)
    end
  end
end
