# frozen_string_literal: true

class ResponseObject
  attr_reader :status, :body

  def initialize(status:, body: {})
    validate_status!(status)

    @status = status
    @body = body
  end

  private

  def validate_status!(status)
    raise "Status #{status.inspect} not supported" if invalid_status?(status)
  end

  def invalid_status?(status)
    %i[
      ok
      no_content
      created
      internal_server_error
      bad_request
      expectation_failed
      unprocessable_entity
    ].exclude?(status)
  end
end
