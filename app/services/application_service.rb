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
end
