class CreateTables < ActiveRecord::Migration[7.2]
  def change
    create_table :tables do |t|
      t.integer :capacity, null: false

      t.timestamps
    end
  end
end
