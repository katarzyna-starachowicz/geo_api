# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GivenAreasService do
  let(:points_cooridnates) do
    [
      [-119.61914062499999, 33.578014746143985],
      [-113.37890625, 30.90222470517144],
      [-105.99609375, 31.12819929911196],
      [-105.29296874999999, 32.99023555965106],
      [-105.8203125, 35.02999636902566],
      [-106.962890625, 35.31736632923788],
      [-108.544921875, 35.53222622770337],
      [-114.08203125, 35.38904996691167],
      [-118.564453125, 38.13455657705411],
      [-120.58593749999999, 42.293564192170095],
      [-120.41015624999999, 45.089035564831036],
      [-118.47656249999999, 46.619261036171515],
      [-116.01562499999999, 47.040182144806664],
      [-110.478515625, 46.98025235521883],
      [-107.841796875, 44.902577996288876],
      [-105.99609375, 40.78054143186033],
      [-104.94140625, 36.80928470205937],
      [-103.798828125, 33.87041555094183],
      [-100.986328125, 34.08906131584994],
      [-100.283203125, 39.095962936305476],
      [-101.42578124999999, 45.336701909968134],
      [-106.435546875, 50.233151832472245],
      [-117.861328125, 50.233151832472245],
      [-123.74999999999999, 46.558860303117164],
      [-124.01367187499999, 39.027718840211605],
      [-119.61914062499999, 33.578014746143985]
    ]
  end

  let(:polygon) do
    OpenStruct.new(
      points: points_cooridnates.map do |coordinates|
        OpenStruct.new(
          longitude: coordinates[0],
          latitude: coordinates[1]
        )
      end
    )
  end

  before do
    allow(service).to receive(:polygons)
      .and_return([polygon])
  end

  let(:service) { subject }

  describe '#point_inside?' do
    context 'point is inside' do
      let(:location_point) do
        OpenStruct.new(longitude: -103.40, latitude: 42.35)
      end

      it 'returns true' do
        expect(service.point_inside?(location_point)).to be(true)
      end

      context 'and intersects the polygon vertex' do
        let(:location_point) do
          OpenStruct.new(longitude: -102.2832031, latitude: 39.0959629)
        end

        it 'returns true' do
          expect(service.point_inside?(location_point)).to be(true)
        end
      end
    end

    context 'point is outside' do
      let(:location_point) do
        OpenStruct.new(longitude: -98.42, latitude: 42.35)
      end

      it 'returns false' do
        expect(service.point_inside?(location_point)).to be(false)
      end
    end

    context 'point is the vertex on the polygon very right side' do
      let(:location_point) do
        OpenStruct.new(longitude: -100.2832031, latitude: 39.0959629)
      end

      it 'returns true' do
        expect(service.point_inside?(location_point)).to be(true)
      end
    end

    context 'point is the vertex on the polygon very left side' do
      let(:location_point) do
        OpenStruct.new(longitude: -124.01367187499999, latitude: 39.027718840211605)
      end

      it 'returns true' do
        expect(service.point_inside?(location_point)).to be(true)
      end
    end
  end
end
