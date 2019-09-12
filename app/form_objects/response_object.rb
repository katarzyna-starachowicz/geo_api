# frozen_string_literal: true

class ResponseObject
  attr_reader :status, :json

  def initialize(status:, json:)
    validate_status!(status)

    @status = status
    @json = json
  end

  private

  def validate_status!(status)
    raise "Status #{status.inspect} not supported" if invalid_status?(status)
  end

  def invalid_status?(status)
    %i[ok no_content created internal_server_error bad_request].exclude?(status)
  end
end
