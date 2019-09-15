# frozen_string_literal: true

module FakeGeocodingAdapter
  class Success
    def determine_coordinates_of(_location_name)
      ::ResponseObject.new(
        status: :ok,
        body: {
          latitude: 35.6803997,
          longitude: 139.7690174
        }
      )
    end
  end

  class Unsuccess
    def determine_coordinates_of(_location_name)
      ::ResponseObject.new(
        status: :no_content
      )
    end
  end

  class ProviderServerError
    def determine_coordinates_of(_location_name)
      ::ResponseObject.new(
        status: :internal_server_error
      )
    end
  end

  class UnsupportedStatus
    def determine_coordinates_of(_location_name)
      ::ResponseObject.new(
        status: :created
      )
    end
  end
end
