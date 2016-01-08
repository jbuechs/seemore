require 'rails_helper'

RSpec.describe Creator, type: :model do
  it { is_expected.to validate_presence_of(:p_id) }
  it { is_expected.to validate_presence_of(:provider) }
  it { is_expected.to validate_presence_of(:username) }

end
