class Creator < ActiveRecord::Base
  has_many :content
  validates :p_id, :provider, :username, presence: true
end
