require "rails_helper"

RSpec.describe IncidentSerializer, type: :serializer do
  let(:reporter) { create(:reporter) }
  let(:incident_type) { create(:incident_type) }
  let!(:incident) { create(:incident, reporter_id: reporter.id, incident_type_id: incident_type.id) }
  let!(:follow) { create(:follow, follower_id: reporter.id, following_id: incident.id) }
  subject { described_class }

  it "checks that the response is not empty" do
    response = subject.new(incident).to_json
    expect(response).not_to be_nil
  end

  it "returns a hash" do
    response = subject.new(incident).to_json
    expect(JSON.parse(response)).to be_a Object
  end

  it "reaches the following_count method" do
    response = subject.new(incident).following_count
    expect(response).to be_a Object
  end

  it "has following_count" do
    response = subject.new(incident).to_json
    expect(JSON.parse(response)["following_count"]).to eq(1)
  end

  it "has reporter details" do
    response = subject.new(incident).to_json
    expect(JSON.parse(response)["reporter"]).to be_a Object
    expect(JSON.parse(response)["reporter"]["id"]).to eq(reporter.id)
  end
end
