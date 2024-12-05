class Post < ApplicationRecord
  belongs_to :category
  belongs_to :user

  validates :title, :body, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["body", "category_id", "created_at", "id", "id_value", "title", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category", "user"]
  end
end
