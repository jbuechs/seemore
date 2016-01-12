class Content < ActiveRecord::Base
  belongs_to :creator
  validates :content_id, :text, :create_time, :favorites, :embed_code, :creator_id, presence: true
end
