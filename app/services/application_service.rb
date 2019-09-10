# frozen_string_literal: true

class ApplicationService
  def fetch_given_areas
    given_areas = ::GivenAreas::DataFromFile.read

    ::ResponseObject.new(
      status: given_areas.present? ? :ok : :no_content,
      json: given_areas
    )
  end
end
