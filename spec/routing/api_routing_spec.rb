# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'api routing', :aggregate_failures, type: :routing do
  describe 'given areas fetching' do
    it 'routes api' do
      expect(get: 'api/v1/given_areas')
        .to route_to(format: 'json', controller: 'api/v1/given_areas', action: 'index')
    end
  end

  describe 'new location creating' do
    it 'routes api' do
      expect(post: 'api/v1/locations')
        .to route_to(format: 'json', controller: 'api/v1/locations', action: 'create')
    end
  end

  describe 'given location fetching' do
    it 'routes api' do
      expect(get: 'api/v1/locations/1')
        .to route_to(format: 'json', controller: 'api/v1/locations', action: 'show', id: '1')
    end
  end
end
