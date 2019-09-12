class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.string :status, null: false, default: 'just_created'

      t.timestamps
    end
  end
end
