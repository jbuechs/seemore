class Creator < ActiveRecord::Base
  has_many :content
  has_and_belongs_to_many :users
  validates :p_id, :provider, :username, presence: true

  def has_image?
    if avatar_url.nil?
      false
    else
      true
    end
  end
end
