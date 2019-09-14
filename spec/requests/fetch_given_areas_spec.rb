# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'fetch given areas', type: :request do
  context 'sunny day scenario' do
    before do
      expect_any_instance_of(ApplicationService)
        .to receive(:fetch_given_areas)
        .and_return(response_object)
    end

    let(:response_object) do
      ResponseObject.new(
        status: :ok,
        body: { given_areas: 'given_areas' }
      )
    end

    it 'lists given areas' do
      get '/api/v1/given_areas'

      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(:ok)
    end
  end

  context 'not supported application error' do
    before do
      expect_any_instance_of(ApplicationService)
        .to receive(:fetch_given_areas)
        .and_raise('Some unsupported error')
    end

    it 'lists given areas' do
      get '/api/v1/given_areas'

      expect(response).to have_http_status(:internal_server_error)
    end
  end
end
