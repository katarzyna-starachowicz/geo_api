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
    let(:new_location) { double('new_location', save: nil, id: 389, name: 'Tokio') }

    before do
      allow(Location)
        .to receive(:find_or_create_by)
        .with(name: 'Tokio')
        .and_return(new_location)

      allow(DetermineLocationCoordinatesJob)
        .to receive(:perform_later)
        .with('Tokio', 389)
    end

    it 'returns response object with :created status' do
      expect(subject.create_location(name: 'Tokio', status: 'just_created').status).to eq(:created)
    end

    it 'returns response object with location id in body' do
      expect(subject.create_location(name: 'Tokio', status: 'just_created').body).to eq(location_id: 389)
    end
  end

  describe '#fetch_location' do
    let(:location_attributes) { { id: 22 } }
    let(:point) { Point.new(latitude: 35.6803997, longitude: 139.7690174) }
    let(:location) { double('location', name: 'Tokio', status: location_status, point: point) }

    before do
      expect(Location)
        .to receive(:find)
        .with(22)
        .and_return(location)
    end

    context 'sunny scenario' do
      let(:location_status) { 'coordinates_determinated' }
      let(:response_body) do
        {
          name: 'Tokio',
          latitude: 35.6803997,
          longitude: 139.7690174
        }
      end

      it 'returns response object with :ok status' do
        expect(subject.fetch_location(id: 22).status).to eq(:ok)
      end

      it 'returns response object with location information in body' do
        expect(subject.fetch_location(id: 22).body).to eq(response_body)
      end
    end

    context 'coordinates not yet determinated' do
      let(:location_status) { 'just_created' }

      it 'returns response object with :no_content status' do
        expect(subject.fetch_location(id: 22).status).to eq(:no_content)
      end
    end

    context 'coordinates could not have been determinated' do
      let(:location_status) { 'coordinates_indeterminated' }

      it 'returns response object with :unprocessable_entity status' do
        expect(subject.fetch_location(id: 22).status).to eq(:unprocessable_entity)
      end
    end

    context 'unsupported location status' do
      let(:location_status) { 'unsupported_status' }

      it 'raises error' do
        expect { subject.fetch_location(id: 22) }
          .to raise_error('Unsupported location status unsupported_status')
      end
    end
  end
end
