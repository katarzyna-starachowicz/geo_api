# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'fetch location', type: :request do
  context 'valid request' do
    let(:response_body) { {} }

    let(:response_object) do
      ResponseObject.new(
        status: status,
        body: response_body
      )
    end

    before do
      expect_any_instance_of(ApplicationService)
        .to receive(:fetch_location)
        .with(id: 22)
        .and_return(response_object)
    end

    context 'sunny day scenario' do
      let(:status) { :ok }

      let(:response_body) do
        {
          name: 'Tokio',
          latitude: 35.6803997,
          longitude: 139.7690174
        }
      end

      it 'fetches location information' do
        get '/api/v1/locations/22'

        expect(response).to have_http_status(status)
        expect(JSON.parse(response.body)).to eq(response_body.stringify_keys)
      end
    end

    context 'id does not exists' do
      let(:status) { :expectation_failed }

      let(:response_body) do
        {
          'error' => {
            'id' => ["Couldn't find Location with 'id'=5000"]
          }
        }
      end

      it 'returns :bad_request' do
        get '/api/v1/locations/22'

        expect(response).to have_http_status(status)
        expect(JSON.parse(response.body)).to eq('error' => { 'id' => ["Couldn't find Location with 'id'=5000"] })
      end
    end

    context 'not yest determinated coordinates' do
      let(:status) { :no_content }

      it 'returns :no_content' do
        get '/api/v1/locations/22'

        expect(response).to have_http_status(status)
      end
    end

    context 'coordinated could not have been determinated' do
      let(:status) { :unprocessable_entity }

      it 'returns :unprocessable_entity' do
        get '/api/v1/locations/22'

        expect(response).to have_http_status(status)
      end
    end
  end

  context 'invalid id format' do
    it 'returns :bad_request' do
      get '/api/v1/locations/bb'

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)).to eq('error' => { 'id' => ['must be an integer'] })
    end
  end
end
