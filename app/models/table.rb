class Table < ApplicationRecord
  has_many :reservation_tables
  has_many :reservations, through: :reservation_tables

  def occupied_timestamps
    reservations.pluck(:time)
  end
end
