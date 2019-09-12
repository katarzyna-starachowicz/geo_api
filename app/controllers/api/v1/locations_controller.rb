# frozen_string_literal: true

module Api
  module V1
    class LocationsController < ApplicationController
      def create
        create_location_form = CreateLocationForm.new
        validation_result = create_location_form.call(create_location_params)

        if validation_result.failure?
          respond_with(
            ::ResponseObject.new(
              status: :bad_request,
              json: { error: validation_result.errors.to_h }
            )
          )
        else
          respond_with(application.create_location(validation_result.to_h))
        end
      rescue StandardError
        # TODO, log errors
        render status: :internal_server_error
      end

      private

      def create_location_params
        params.permit(:name).to_hash
      end
    end
  end
end
