require 'rails_helper'

RSpec.describe 'CommentReplies',  type: :request do
  let(:reporter) { create(:reporter) }
  let(:incident_type) { create(:incident_type) }
  let(:incident) { create(:incident, reporter_id: reporter.id, incident_type_id: incident_type.id) }
  let(:comment) { create(:comment, reporter_id: reporter.id, incident_id: incident.id) }
  let(:headers) do
    {
      "Authorization" => token_generator(reporter.id),
      "Content-Type" => "application/json"
    }
  end
  let(:valid_attributes) { attributes_for(:comment_reply) }
  
  describe 'POST #create' do
    context 'when valid request' do
      before { 
        post "/incidents/#{incident.id}/comments/#{comment.id}/comment_replies", params: valid_attributes.to_json, headers: headers 
      }

      it 'replies to comment' do
        expect(response).to have_http_status(201)
      end

      it 'returns a success message' do
        expect(json_response[:message]).to match(/Reply was reported successfully/)
      end
    end

    context 'when invalid request' do
      before {
        post "/incidents/#{incident.id}/comments/#{comment.id}/comment_replies", params: {}, headers: headers 
      }

      it 'does not reply to comment' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(json_response[:error]).to match(/Validation failed/)
      end
    end
  end
end
