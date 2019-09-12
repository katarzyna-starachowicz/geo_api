# frozen_string_literal: true

class ApplicationService
  def fetch_given_areas
    given_areas = ::GivenAreas::DataFromFile.read

    ::ResponseObject.new(
      status: given_areas.present? ? :ok : :no_content,
      json: given_areas
    )
  end

  def create_location(location_attributes)
    new_location = Location.new(location_attributes)
    new_location.save

    ::ResponseObject.new(
      status: :created,
      json: { location_id: new_location.id }
    )
  end
end
