# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationService do
  describe '#fetch_given_areas' do
    before do
      allow(GivenAreas::DataFromFile)
        .to receive(:read)
        .and_return(given_areas)
    end

    context 'content is present' do
      let(:given_areas) { { key: 'value' } }

      it 'returns respons object with :ok status' do
        expect(subject.fetch_given_areas.status).to eq(:ok)
      end
    end

    context 'content is absent' do
      let(:given_areas) { nil }

      it 'returns respons object with :ok status' do
        expect(subject.fetch_given_areas.status).to eq(:no_content)
      end
    end
  end
end
