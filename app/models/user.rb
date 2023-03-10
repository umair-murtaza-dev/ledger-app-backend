class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,
         jwt_revocation_strategy: JwtDenylist
  belongs_to :company
  has_many :expenses

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
    'lastname' => lastname
  }
  end

  def name
  {
    'firstname' => firstname
  }
  end
end
