class User < ApplicationRecord
    require 'securerandom'

    has_secure_password

    has_many :posts, dependent: :destroy

    validates :email, presence: true
    validates :password, presence: true
    validates :language, presence: true
    validates :username, presence: true, uniqueness: true

    enum language: { english: 0, arabic: 1, spanish: 2, hindi: 3, french: 4}

end
