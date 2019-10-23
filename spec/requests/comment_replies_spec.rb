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

  describe 'DELETE #destroy' do
    let(:comment_reply) { create(:comment_reply, comment_id: comment.id, reporter_id: reporter.id) }

    context 'when valid request' do
      before { delete "/incidents/#{incident.id}/comments/#{comment.id}/comment_replies/#{comment_reply.id}", headers: headers }

      it 'returns an ok response' do
        expect(response).to have_http_status(200)
      end

      it 'returns a success message' do
        expect(json_response[:message]).to match(/Reply was deleted successfully/)
      end
    end

    context 'when invalid request for another reply' do
      before { delete "/incidents/#{incident.id}/comments/#{comment.id}/comment_replies/#{comment_reply.id * 11}", headers: headers }

      it 'returns a unprocessable status' do
        expect(response).to have_http_status(404)
      end

      it 'returns an error message' do
        expect(json_response[:error]).to match(/Couldn't find CommentReply/)
      end
    end

    context 'when valid request for admin' do
      let(:admin) { create(:admin) }
      let(:headers) do
        {
          "Authorization" => token_generator(admin.id),
          "Content-Type" => "application/json"
        }
      end

      before { delete "/incidents/#{incident.id}/comments/#{comment.id}/comment_replies/#{comment_reply.id}", headers: headers }

      it 'returns an ok response' do
        expect(response).to have_http_status(200)
      end

      it 'returns a success message' do
        expect(json_response[:message]).to match(/Reply was deleted successfully/)
      end
    end

    context 'when invalid request for another user' do
      let(:reporterx) { create(:reporterx) }
      let(:comment_reply) { create(:comment_reply, comment_id: comment.id, reporter_id: reporterx.id) }

      before { delete "/incidents/#{incident.id}/comments/#{comment.id}/comment_replies/#{comment_reply.id}", headers: headers }

      it 'returns a unprocessable status' do
        expect(response).to have_http_status(401)
      end

      it 'returns an error message' do
        expect(json_response[:error]).to match(/Unauthorized request/)
      end
    end
  end
end
