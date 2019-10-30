require "rails_helper"

RSpec.describe CommentSerializer, type: :serializer do
  let(:reporter) { create(:reporter) }
  let(:incident_type) { create(:incident_type) }
  let!(:incident) { create(:incident, reporter_id: reporter.id, incident_type_id: incident_type.id) }
  let!(:comment) { create(:comment, reporter_id: reporter.id, incident_id: incident.id) }
  let!(:comment_reply) { create(:comment_reply, comment_id: comment.id, reporter_id: reporter.id) }
  subject { described_class }

  it "checks that the response is not empty" do
    response = subject.new(comment).to_json
    expect(response).not_to be_nil
  end

  it "returns a hash" do
    response = subject.new(comment).to_json
    expect(JSON.parse(response)).to be_a Object
  end

  it "has reporter details" do
    response = subject.new(comment).to_json
    expect(JSON.parse(response)["reporter"]).to be_a Object
    expect(JSON.parse(response)["reporter"]["id"]).to eq(reporter.id)
  end

  it "reaches the comment_replies method" do
    response = subject.new(comment).comment_replies
    expect(response).not_to be_nil
    expect(response).to be_a Array
  end

  it "has comment_replies" do
    response = subject.new(comment).to_json
    expect(JSON.parse(response)["comment_replies"].length).to eq(1)
  end

  it "has comment reply reporter details" do
    response = subject.new(comment).comment_replies.to_json
    expect(JSON.parse(response)[0]["comment_reply_reporter"]).to be_a Object
    expect(JSON.parse(response)[0]["comment_reply_reporter"]["id"]).to eq(reporter.id)
  end
end
