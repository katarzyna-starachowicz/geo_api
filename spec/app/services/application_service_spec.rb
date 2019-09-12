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

      it 'returns response object with :ok status' do
        expect(subject.fetch_given_areas.status).to eq(:ok)
      end
    end

    context 'content is absent' do
      let(:given_areas) { nil }

      it 'returns response object with :ok status' do
        expect(subject.fetch_given_areas.status).to eq(:no_content)
      end
    end
  end

  describe '#create_location' do
    let(:new_location) { double('new_location', save: nil, id: 389) }

    before do
      allow(Location)
        .to receive(:new)
        .with(name: 'Tokio', status: 'just_created')
        .and_return(new_location)
    end

    it 'returns response object with :created status' do
      expect(subject.create_location(name: 'Tokio', status: 'just_created').status).to eq(:created)
    end

    it 'returns response object with location id in json' do
      expect(subject.create_location(name: 'Tokio', status: 'just_created').json).to eq(location_id: 389)
    end
  end
end
