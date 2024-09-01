class CreateReservationTables < ActiveRecord::Migration[7.2]
  def change
    create_table :reservation_tables do |t|
      t.references :table, null: false, foreign_key: true
      t.references :reservation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
