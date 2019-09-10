# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

  def application
    ::ApplicationService.new
  end

  def respond_with(response_object)
    render status: response_object.status, json: response_object.json
  end
end
