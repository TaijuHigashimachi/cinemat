# Schema Information
#
# Table name: movies
#
# name               :string not null
# email              :string not null uniqueness
# avatar             :string
# role               :integer
# crypted_password   :string
# salt               :string
#

class User < ApplicationRecord
  authenticates_with_sorcery!
  mount_uploader :avatar, AvatarUploader

  has_many :movie_statuses, dependent: :destroy

  validates :name, presence: true, length: { maximum: 10 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  enum role: { general: 0, admin: 1 }
end
