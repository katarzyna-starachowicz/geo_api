# frozen_string_literal: true

module Api
  module V1
    class GivenAreasController < ApplicationController
      def index
        respond_with(application.fetch_given_areas)
      rescue StandardError
        # TODO, log errors
        render status: :internal_server_error
      end
    end
  end
end
