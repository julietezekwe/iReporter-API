require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "Associations" do
    it { should belong_to(:incident) }
    it { should belong_to(:reporter) }
  end

  describe "Validations" do
    it { validate_presence_of(:body) }
    it { validate_presence_of(:reporter_id) }
    it { validate_presence_of(:incident_id) }
  end
end
