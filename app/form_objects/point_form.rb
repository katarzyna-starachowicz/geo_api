# frozen_string_literal: true

class PointForm < Dry::Validation::Contract
  params do
    required(:latitude).value(::Types::Strict::Float)
    required(:longitude).value(::Types::Strict::Float)
  end

  rule(:latitude) do
    key.failure('must be bigger than -180 and lower than 180') if value < -180.0 || value > 180.0
  end

  rule(:latitude) do
    key.failure('must be bigger than -180 and lower than 180') if value < -180.0 || value > 180.0
  end
end
