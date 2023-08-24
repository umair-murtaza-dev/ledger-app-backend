class User < ApplicationRecord
  acts_as_paranoid

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,
         jwt_revocation_strategy: JwtDenylist

  belongs_to :company
  belongs_to :role, optional: true
  has_many :expenses
  has_many :invoices

  # def jwt
  #   Warden::JWTAuth::UserEncoder.new.call(self, :user, 'aud')&.first
  # end

  def generate_jwt
  JWT.encode({ id: id,
              exp: 60.days.from_now.to_i },
             Rails.application.secret_key_base)
  end

  def attributes
  {
    'id' => self.id,
    'firstname' => firstname,
    'lastname' => lastname,
    'email' => email,
    'role_title' => role_title
  }
  end

  def name
  {
    'firstname' => firstname
  }
  end

  def role_title
    self.role&.title
  end
end
