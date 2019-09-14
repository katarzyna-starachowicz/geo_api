# frozen_string_literal: true

class GeocodingService
  def determine_location_coordinates(location_name, location_id)
    determination_response = geocoding_adapter.determine_coordinates_of(location_name)
    location = ::Location.find(location_id)

    case determination_response.status
    when :internal_server_error
      raise ::GeocodingProviderServerError
    when :no_content, :unprocessable_entity
      location.update(
        status: 'coordinates_indeterminated'
      )
    when :ok
      location_point = ::Point.find_or_create_by(determination_response.body)

      location.update(
        status: 'coordinates_determinated',
        point_id: location_point.id
      )
    else
      raise "Unsupported status #{determination_response.status}"
    end
  end

  private

  def geocoding_adapter
    ::GeocodingAdapter.new
  end
end
