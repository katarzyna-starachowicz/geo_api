# frozen_string_literal: true

class GeocodingAdapter
  include HTTParty
  base_uri 'https://maps.googleapis.com'
  default_params key: ENV.fetch('GOOGLE_GEOCODING_API_KEY')

  def determine_coordinates_of(location_name)
    response = self.class.get('/maps/api/geocode/json', query: { address: location_name }).parsed_response

    return parsed_success_response(response) if response['status'].eql?('OK')

    ::ResponseObject.new(
      status: adapter_response_status(response['status'])
    )
  end

  private

  def adapter_response_status(geocoding_api_status)
    case geocoding_api_status
    when 'UNKNOWN_ERROR'
      :internal_server_error
    when 'ZERO_RESULTS'
      :no_content
    else
      :unprocessable_entity
    end
  end

  def parsed_success_response(response)
    response_location = response['results'].first['geometry']['location']
    point_form = ::PointForm.new

    validation_result = point_form.call(
      latitude: response_location['lat'],
      longitude: response_location['lng']
    )

    if validation_result.failure?
      ::ResponseObject.new(status: :unprocessable_entity)
    else
      ::ResponseObject.new(
        status: :ok,
        body: validation_result.to_h
      )
    end
  end
end
