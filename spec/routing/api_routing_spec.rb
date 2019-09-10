# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'api routing', :aggregate_failures, type: :routing do
  it 'routes api' do
    expect(get: 'api/v1/given_areas')
      .to route_to(format: 'json', controller: 'api/v1/given_areas', action: 'index')
  end
end
