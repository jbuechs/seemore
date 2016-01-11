class Creator < ActiveRecord::Base
  has_many :content
  validates :p_id, :provider, :username, presence: true

  def has_image?
    if avatar_url.nil?
      false
    else
      true
    end
  end
end
