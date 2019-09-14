require 'rails_helper'

RSpec.describe IncidentType, type: :model do
  describe "Associations" do
    it { should have_many(:incidents) }
  end

  describe "Validations" do
    it { validate_presence_of(:title) }
  end
end
