# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :given_areas, only: %i[index]
      resources :locations, only: %i[create show]
    end
  end
end
