class CreateTrips < ActiveRecord::Migration[6.0]
  def change
    create_table :trips do |t|
      t.bigint :driver_id
      t.bigint :passenger_id
      t.string :date
      t.integer :rating
      t.float :cost

      t.timestamps
    end
  end
end
