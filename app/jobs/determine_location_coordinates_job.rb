# frozen_string_literal: true

class DetermineLocationCoordinatesJob < ApplicationJob
  queue_as :default

  rescue_from(::GeocodingProviderServerError) do
    retry_job wait: 3.minutes, queue: :default
  end

  def perform(location_name, location_id)
    geolocation_service = ::GeocodingService.new

    geolocation_service
      .determine_location_coordinates(location_name, location_id)
  end
end
