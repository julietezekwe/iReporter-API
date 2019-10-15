require 'rails_helper'

RSpec.describe Reporter, type: :model do
  describe "Associations" do
    it { should have_many(:reported_incidents) }
    it { should have_many(:follows) }
    it { should have_many(:followed_incidents) }
    it { should have_many(:comments) }
  end

  describe "Validations" do
    it { validate_presence_of(:name) }
    it { validate_presence_of(:email) }
  end
end
