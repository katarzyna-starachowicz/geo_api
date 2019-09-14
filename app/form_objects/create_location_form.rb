# frozen_string_literal: true

class CreateLocationForm < Dry::Validation::Contract
  params do
    required(:name).value(::Types::Strict::String)
  end

  rule(:name) do
    key.failure('cannot be empty') if value.blank?
  end
end
