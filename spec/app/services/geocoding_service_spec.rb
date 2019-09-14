# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GeocodingService do
  describe '#determine_lcoation_coordinates' do
    let(:service) { described_class.new }
    let(:location_name) { 'Tokio' }
    let(:location_id)   { 29 }

    let(:location) do
      Location.new(
        id: location_id,
        name: location_name
      )
    end

    let(:location_point) do
      Point.new(
        latitude: 35.6803997,
        longitude: 139.7690174,
        id: 11
      )
    end

    before do
      allow(service).to receive(:geocoding_adapter)
        .and_return(geocoding_adapter)

      allow(Location).to receive(:find)
        .with(29)
        .and_return(location)
    end

    context 'sunny day scenario' do
      let(:geocoding_adapter) { FakeGeocodingAdapter::Success.new }

      it 'updates given location' do
        expect(Point).to receive(:find_or_create_by)
          .with(latitude: 35.6803997, longitude: 139.7690174)
          .and_return(location_point)

        expect(location).to receive(:update)
          .with(
            status: 'coordinates_determinated',
            point_id: 11
          )

        service.determine_location_coordinates(location_name, location_id)
      end
    end

    context 'unsuccessful response without server error' do
      let(:geocoding_adapter) { FakeGeocodingAdapter::Unsuccess.new }

      it 'updates location' do
        expect(location).to receive(:update)
          .with(status: 'coordinates_indeterminated')

        service.determine_location_coordinates(location_name, location_id)
      end
    end

    context 'geocoding provider server error' do
      let(:geocoding_adapter) { FakeGeocodingAdapter::ProviderServerError.new }

      it 'raises custom error' do
        expect { service.determine_location_coordinates(location_name, location_id) }
          .to raise_error(GeocodingProviderServerError)
      end
    end

    context 'unsupported response status' do
      let(:geocoding_adapter) { FakeGeocodingAdapter::UnsupportedStatus.new }

      it 'raises error' do
        expect { service.determine_location_coordinates(location_name, location_id) }
          .to raise_error('Unsupported status created')
      end
    end
  end
end
