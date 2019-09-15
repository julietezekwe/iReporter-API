require 'rails_helper'

RSpec.describe Follow, type: :model do
  describe "Associations" do
    it { should belong_to(:follower) }
    it { should belong_to(:following) }
  end

  describe "Validations" do
    it { validate_presence_of(:follower_id) }
    it { validate_presence_of(:following_id) }
  end
end
