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
  
  describe 'POST #create' do
    context 'when valid request' do
      before do
        valid_attributes[:reporter_id] = reporter.id
        valid_attributes[:incident_type_id] = incident_type.id
        post '/incidents', params: valid_attributes.to_json, headers: headers
      end

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

      it 'returns an ok response' do
        expect(response).to have_http_status(200)
      end

      it 'returns an incident' do
        expect(json_response[:data]).not_to be_nil
      end
    end

    context 'when invalid request' do
      before { get '/incidents/1', headers: headers }

      it 'returns an ok response' do
        expect(response).to have_http_status(404)
      end

      it 'returns an incident' do
        expect(json_response[:error]).to match(/Couldn't find Incident/)
      end
    end
  end
end
