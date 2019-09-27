require 'rails_helper'

RSpec.describe 'Follows', type: :request do
  let(:reporter) { create(:reporter) }
  let(:incident_type) { create(:incident_type) }
  let(:incident) { create(:incident, reporter_id: reporter.id, incident_type_id: incident_type.id) }
  let(:headers) do
    {
      "Authorization" => token_generator(reporter.id),
      "Content-Type" => "application/json"
    }
  end

  describe 'POST #create' do
    context 'when valid follow request' do
      before { post "/incidents/#{incident.id}/follows", headers: headers }

      it 'return a created status' do
        expect(response).to have_http_status(:created)
      end

      it 'return a success message' do
        expect(json_response[:message]).to match(/Incident followed successfully/)
      end

      it 'returns the follow data' do
        expect(json_response[:data]).not_to be_nil
      end
    end

    context 'when valid unfollow request' do
      let!(:follow) { create(:follow, follower_id: reporter.id, following_id: incident.id) }
      before { post "/incidents/#{incident.id}/follows", headers: headers }

      it 'return a created status' do
        expect(response).to have_http_status(:ok)
      end

      it 'return a success message' do
        expect(json_response[:message]).to match(/Incident unfollowed successfully/)
      end

      it 'returns the no data' do
        expect(json_response[:data]).to be_nil
      end
    end
  end
end
