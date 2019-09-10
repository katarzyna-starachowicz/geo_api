# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResponseObject do
  context 'sunny day scenario' do
    let(:response_object) do
      described_class.new(status: :no_content, json: {})
    end

    it 'returns set status' do
      expect(response_object.status).to eq(:no_content)
    end

    it 'returns set json' do
      expect(response_object.json).to eq({})
    end
  end

  context 'invalid status' do
    it 'raises error' do
      expect { described_class.new(status: :invalid_status, json: {}) }
        .to raise_error('Status :invalid_status not supported')
    end
  end
end
