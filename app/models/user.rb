class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,
         jwt_revocation_strategy: JwtDenylist
  belongs_to :company

  # def jwt
  #   Warden::JWTAuth::UserEncoder.new.call(self, :user, 'aud')&.first
  # end

  def generate_jwt
  JWT.encode({ id: id,
              exp: 60.days.from_now.to_i },
             Rails.application.secrets.secret_key_base)
  end
end
