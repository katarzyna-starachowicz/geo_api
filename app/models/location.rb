# frozen_string_literal: true

class Location < ApplicationRecord
  belongs_to :point, optional: true
end
