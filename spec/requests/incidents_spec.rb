require 'rails_helper'

RSpec.describe 'Incidents', type: :request do
  let(:reporter) { create(:reporter) }
  let(:incident_type) { create(:incident_type) }
  let(:headers) do
    {
      "Authorization" => token_generator(reporter.id),
      "Content-Type" => "application/json"
    }
  end
  let(:valid_attributes) { attributes_for(:incident) }

  before do
    valid_attributes[:reporter_id] = reporter.id
    valid_attributes[:incident_type_id] = incident_type.id
  end
  
  describe 'POST #create' do
    context 'when valid request' do
      before { post '/incidents', params: valid_attributes.to_json, headers: headers }

      it 'creates a new incident' do
        expect(response).to have_http_status(201)
      end

      it 'returns a success message' do
        expect(json_response[:message]).to match(/Incident was reported successfully/)
      end
    end

    context 'when invalid request' do
      before { post '/incidents', params: {}, headers: headers }

      it 'does not create incident' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(json_response[:error]).to match(/Validation failed/)
      end
    end
  end

  describe 'GET #show' do
    context 'when valid request' do
      let(:incident) { create(:incident, reporter_id: reporter.id, incident_type_id: incident_type.id) }

      before do
        get "/incidents/#{incident.id}", headers: headers
      end

      it 'returns an ok status' do
        expect(response).to have_http_status(200)
      end

      it 'returns an incident' do
        expect(json_response[:data]).not_to be_nil
      end
    end

    context 'when invalid request' do
      before { get '/incidents/1', headers: headers }

      it 'returns an not found status' do
        expect(response).to have_http_status(404)
      end

      it 'returns an incident' do
        expect(json_response[:error]).to match(/Couldn't find Incident/)
      end
    end
  end

  describe 'PUT #update' do
    context 'when valid request for user' do
      let(:incident) { create(:incident, reporter_id: reporter.id, incident_type_id: incident_type.id) }

      before { put "/incidents/#{incident.id}", params: valid_attributes.to_json, headers: headers }

      it 'returns an ok response' do
        expect(response).to have_http_status(200)
      end

      it 'returns a success message' do
        expect(json_response[:message]).to match(/Incident was updated successfully/)
      end

      it 'returns the updated incident' do
        expect(json_response[:data]).not_to be_nil
      end
    end

    context 'when valid request for admin' do
      let(:incident) { create(:incident, reporter_id: reporter.id, incident_type_id: incident_type.id) }
      let(:admin) { create(:admin) }
      let(:headers) do
        {
          "Authorization" => token_generator(admin.id),
          "Content-Type" => "application/json"
        }
      end

      before { put "/incidents/#{incident.id}", params: { status: "investigating" }.to_json, headers: headers }

      it 'returns an ok response' do
        expect(response).to have_http_status(200)
      end

      it 'returns a success message' do
        expect(json_response[:message]).to match(/Incident was updated successfully/)
      end

      it 'returns the updated incident' do
        expect(json_response[:data][:status]).to match(/investigating/)
      end
    end

    context 'when invalid request' do
      let(:incident) { 
        create(:incident, status: "resolved", reporter_id: reporter.id, incident_type_id: incident_type.id)
      }

      before { put "/incidents/#{incident.id}", params: valid_attributes.to_json, headers: headers }

      it 'returns a unprocessable status' do
        expect(response).to have_http_status(422)
      end

      it 'returns a success message' do
        expect(json_response[:error]).to match(/Only Incidents marked as draft, can be updated/)
      end
    end

    context 'when invalid request for another user' do
      let(:reporterx) { create(:reporterx) }
      let(:incident) { 
        create(:incident, reporter_id: reporterx.id, incident_type_id: incident_type.id)
      }

      before { put "/incidents/#{incident.id}", params: valid_attributes.to_json, headers: headers }

      it 'returns a unprocessable status' do
        expect(response).to have_http_status(401)
      end

      it 'returns a success message' do
        expect(json_response[:error]).to match(/Unauthorized request/)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when valid request' do
      let(:incident) { create(:incident, reporter_id: reporter.id, incident_type_id: incident_type.id) }

      before { delete "/incidents/#{incident.id}", headers: headers }

      it 'returns an ok response' do
        expect(response).to have_http_status(200)
      end

      it 'returns a success message' do
        expect(json_response[:message]).to match(/Incident was deleted successfully/)
      end
    end

    context 'when invalid request' do
      let(:incident) { 
        create(:incident, status: "resolved", reporter_id: reporter.id, incident_type_id: incident_type.id)
      }

      before { delete "/incidents/#{incident.id}", headers: headers }

      it 'returns a unprocessable status' do
        expect(response).to have_http_status(422)
      end

      it 'returns a success message' do
        expect(json_response[:error]).to match(/Only Incidents marked as draft, can be deleted/)
      end
    end

    context 'when invalid request for another user' do
      let(:reporterx) { create(:reporterx) }
      let(:incident) { 
        create(:incident, reporter_id: reporterx.id, incident_type_id: incident_type.id)
      }

      before { delete "/incidents/#{incident.id}", headers: headers }

      it 'returns a unprocessable status' do
        expect(response).to have_http_status(401)
      end

      it 'returns a success message' do
        expect(json_response[:error]).to match(/Unauthorized request/)
      end
    end
  end

  describe 'GET #index' do
    context 'when there are no incident' do
      before { get '/incidents', headers: headers }

      it 'returns an empty array' do
        expect(json_response[:data].length).to be_zero
      end
    end

    context 'when valid request' do
      let(:incident) { create(:incident, reporter_id: reporter.id, incident_type_id: incident_type.id) }
      let(:incidentx) { create(:incidentx, reporter_id: reporter.id, incident_type_id: incident_type.id) }
      let(:follow) { create(:follow, follower_id: reporter.id, following_id: incident.id) }

      before do
        get "/incidents", headers: headers
      end

      it 'returns an ok status' do
        expect(response).to have_http_status(200)
      end

      it 'returns all incidents' do
        expect(json_response[:data]).not_to be_nil
      end
    end
  end

end
