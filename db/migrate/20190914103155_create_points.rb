class CreatePoints < ActiveRecord::Migration[5.2]
  def change
    create_table :points do |t|
      t.float :latitude
      t.float :longitude
    end
  end
end
