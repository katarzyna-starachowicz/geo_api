# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GivenAreas::DataFromFile do
  describe '#read' do
    let(:given_areas) { described_class.read }

    it 'returns hash' do
      expect(given_areas).to be_kind_of(Hash)
    end

    it 'returns FeatureCollection' do
      expect(given_areas.fetch('type')).to eq('FeatureCollection')
    end

    it 'returns features collection' do
      expect(given_areas.fetch('features')).to be_kind_of(Array)
    end

    it 'returns collection of Features' do
      given_areas.fetch('features').each do |feature|
        expect(feature.fetch('type')).to eq('Feature')
      end
    end

    it 'returns collection of Polygon Features' do
      given_areas.fetch('features').each do |feature|
        expect(feature.fetch('geometry').fetch('type')).to eq('Polygon')
      end
    end
  end
end
