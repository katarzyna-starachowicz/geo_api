# frozen_string_literal: true

class ApplicationService
  def fetch_given_areas
    given_areas = ::GivenAreas::DataFromFile.read

    ::ResponseObject.new(
      status: given_areas.present? ? :ok : :no_content,
      body: given_areas
    )
  end

  def create_location(location_attributes)
    new_location = ::Location.find_or_create_by(
      name: location_attributes.fetch(:name)
    )

    ::DetermineLocationCoordinatesJob.perform_later(new_location.name, new_location.id)

    ::ResponseObject.new(
      status: :created,
      body: { location_id: new_location.id }
    )
  end

  def fetch_location(location_attributes)
    location = ::Location.find(location_attributes.fetch(:id))

    generate_fetch_location_response_object(location)
  rescue ::ActiveRecord::RecordNotFound => e
    ::ResponseObject.new(
      status: :expectation_failed,
      body: { error: { id: [e.message] } }
    )
  end

  private

  def generate_fetch_location_response_object(location)
    case location.status
    when 'just_created'
      ::ResponseObject.new(status: :no_content)
    when 'coordinates_indeterminated'
      ::ResponseObject.new(status: :unprocessable_entity)
    when 'coordinates_determinated'
      location_point = location.point
      point_inside = GivenAreasService.new.point_inside?(location_point)

      ::ResponseObject.new(
        status: :ok,
        body: {
          name: location.name,
          latitude: location_point.latitude,
          longitude: location_point.longitude,
          inside?: point_inside
        }
      )
    else
      raise "Unsupported location status #{location.status}"
    end
  end
end
