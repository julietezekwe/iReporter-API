require 'rails_helper'

RSpec.describe 'Reporters Controller', type: :request do
  let(:reporter) { build :reporter }
  let(:headers) { { "Content-Type" => "application/json" } }
  let(:valid_attributes) { attributes_for(:reporter) }

  describe 'POST /signup' do
    context 'when valid request' do
      before { post '/signup', params: valid_attributes.to_json, headers: headers }

      it 'creates a new user' do
        expect(response).to have_http_status(201)
      end

      it 'returns success message' do
        expect(json_response[:message]).to match(/Account created successfully/)
      end

      it 'returns an authentication token' do
        expect(json_response[:auth_token]).not_to be_nil
      end
    end

    context 'when invalid request' do
      before { post '/signup', params: {}, headers: headers }

      it 'does not create user' do
        expect(response).to have_http_status(422)
      end

      it 'returns failure message' do
        expect(json_response[:error]).to match("Invalid credentials")
      end
    end

    context 'when invalid request for existing account' do
      let(:reporterx) { create :reporterx }
      before { post '/signup', params: { "name": reporterx.name, "email": reporterx.email, "password": reporterx.password }.to_json, headers: headers } 

      it 'does not create user' do
        expect(response).to have_http_status(422)
      end

      it 'returns failure message' do
        expect(json_response[:error]).to match("Account already exists")
      end
    end
  end
end
