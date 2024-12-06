require 'rails_helper'

RSpec.describe Category, type: :model do
  context 'validations for Category model' do
    let(:category) { build(:category) }
    let(:duplicate_category) { build(:category, name: category.name) }

    it 'is valid with a name' do
      expect(category).to be_valid
    end

    it 'is invalid without a name' do
      category.name = nil
      expect(category).to_not be_valid
      expect(category.errors[:name]).to include("can't be blank")
    end

    it 'is invalid with a duplicate name' do
      category.save
      expect(duplicate_category).to_not be_valid
      expect(duplicate_category.errors[:name]).to include('has already been taken')
    end
  end

  context 'associations for Category model' do
    it 'has many posts' do
      association = described_class.reflect_on_association(:posts)
      expect(association.macro).to eq(:has_many)
    end

    it 'deletes associated posts when the category is deleted' do
      category = create(:category)
      create(:post, category: category)
      create(:post, category: category)

      expect { category.destroy }.to change { Post.count }.by(-2)
    end
  end
end
