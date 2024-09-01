class CreateReservations < ActiveRecord::Migration[7.2]
  def change
    create_table :reservations do |t|
      t.datetime :time, null: false
      t.integer :people_amount, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
