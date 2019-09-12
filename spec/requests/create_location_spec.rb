# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'create location', type: :request do
  context 'sunny day scenario' do
    before do
      expect_any_instance_of(ApplicationService)
        .to receive(:create_location)
        .with(name: 'Tokio', status: 'just_created')
        .and_return(response_object)
    end

    let(:response_object) do
      ResponseObject.new(
        status: :created,
        json: { location_id: 239 }
      )
    end

    it 'creates location and returns its id' do
      post '/api/v1/locations', params: { name: 'Tokio' }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to eq('location_id' => 239)
    end
  end

  context 'invalid params' do
    it 'returns :bad_request' do
      post '/api/v1/locations', params: { name: '' }

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)).to eq('error' => { 'name' => ['cannot be empty'] })
    end
  end

  context 'no params' do
    it 'returns :bad_request' do
      post '/api/v1/locations'

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)).to eq('error' => { 'name' => ['is missing'] })
    end
  end
end
