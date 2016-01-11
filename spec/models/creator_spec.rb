require 'rails_helper'

RSpec.describe Creator, type: :model do
  it { is_expected.to validate_presence_of(:p_id) }
  it { is_expected.to validate_presence_of(:provider) }
  it { is_expected.to validate_presence_of(:username) }

  describe "has_image?" do
    let(:creator) { FactoryGirl.create(:creator) }
    it "returns true when creator object has image" do
      creator.avatar_url = "abc"
      expect(creator.has_image?).to be true
    end
    it "returns false when creator object has no image" do
      expect(creator.has_image?).to be false
    end
  end
end
