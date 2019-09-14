require 'rails_helper'

RSpec.describe Incident, type: :model do
  describe "Associations" do
    it { should belong_to(:incident_type) }
    it { should belong_to(:reporter) }
    it { should have_many(:follows) }
    it { should have_many(:following_reporters)}
  end

  describe "Validations" do
    it { validate_presence_of(:title) }
    it { validate_presence_of(:evidence) }
    it { validate_presence_of(:narration) }
    it { validate_presence_of(:location) }
    it { validate_presence_of(:status) }
    it { validate_presence_of(:reporter_id) }
    it { validate_presence_of(:incident_type_id) }
  end
end
