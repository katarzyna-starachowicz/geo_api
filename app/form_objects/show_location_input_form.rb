# frozen_string_literal: true

class ShowLocationInputForm < Dry::Validation::Contract
  params do
    required(:id).value(:integer)
  end
end
