require 'rails_helper'

RSpec.describe 'Comments',  type: :request do
  let(:reporter) { create(:reporter) }
  let(:incident_type) { create(:incident_type) }
  let(:incident) { create(:incident, reporter_id: reporter.id, incident_type_id: incident_type.id) }
  let(:headers) do
    {
      "Authorization" => token_generator(reporter.id),
      "Content-Type" => "application/json"
    }
  end
  let(:valid_attributes) { attributes_for(:comment) }
  
  describe 'POST #create' do
    context 'when valid request' do
      before { post "/incidents/#{incident.id}/comments", params: valid_attributes.to_json, headers: headers }

      it 'creates a new comment' do
        expect(response).to have_http_status(201)
      end

      it 'returns a success message' do
        expect(json_response[:message]).to match(/Comment was added successfully/)
      end
    end

    context 'when invalid request' do
      before { post "/incidents/#{incident.id}/comments", params: {}, headers: headers }

      it 'does not create comment' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(json_response[:error]).to match(/Validation failed/)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when valid request' do
      let(:comment) { create(:comment, reporter_id: reporter.id, incident_id: incident.id) }

      before { delete "/incidents/#{incident.id}/comments/#{comment.id}", headers: headers }

      it 'returns an ok response' do
        expect(response).to have_http_status(200)
      end

      it 'returns a success message' do
        expect(json_response[:message]).to match(/Comment was deleted successfully/)
      end
    end

    context 'when invalid request for another user' do
      let(:reporterx) { create(:reporterx) }
      let(:comment) { create(:comment, reporter_id: reporterx.id, incident_id: incident.id) }

      before { delete "/incidents/#{incident.id}/comments/#{comment.id}", headers: headers }

      it 'returns a unprocessable status' do
        expect(response).to have_http_status(401)
      end

      it 'returns an error message' do
        expect(json_response[:error]).to match(/Unauthorized request/)
      end
    end

    context 'when valid request for admin' do
      let(:admin) { create(:admin) }
      let(:comment) { create(:comment, reporter_id: reporter.id, incident_id: incident.id) }
      let(:headers) do
        {
          "Authorization" => token_generator(admin.id),
          "Content-Type" => "application/json"
        }
      end

      before { delete "/incidents/#{incident.id}/comments/#{comment.id}", headers: headers }

      it 'returns an ok response' do
        expect(response).to have_http_status(200)
      end

      it 'returns a success message' do
        expect(json_response[:message]).to match(/Comment was deleted successfully/)
      end
    end
  end
end
