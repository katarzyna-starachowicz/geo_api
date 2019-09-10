# frozen_string_literal: true

module GivenAreas
  class DataFromFile
    class << self
      FILE_PATH = 'lib/assets/given_areas.json'

      def read
        # TODO, return valid geo object form istead a hash
        JSON.parse(
          File.read(FILE_PATH)
        )
      end
    end
  end
end
