class User < ActiveRecord::Base
  validates :name, :uid, :provider, presence: true
  has_and_belongs_to_many :creators
  has_many :contents, :through => :creators

  def self.find_or_create_from_omniauth(auth_hash)
    user = self.find_by(uid: auth_hash["uid"], provider: auth_hash["provider"])
    if !user.nil?
      return user
    else
      user = User.new
      user.uid        = auth_hash["uid"]
      user.provider   = auth_hash["provider"]
      user.name       = auth_hash["info"]["name"]
      if user.save
        user
      else
        nil
      end
    end
  end

end
