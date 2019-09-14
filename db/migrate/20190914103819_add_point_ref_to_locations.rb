class AddPointRefToLocations < ActiveRecord::Migration[5.2]
  def change
    add_reference :locations, :point, foreign_key: true
  end
end
