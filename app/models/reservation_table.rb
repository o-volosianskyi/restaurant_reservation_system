class ReservationTable < ApplicationRecord
  belongs_to :table
  belongs_to :reservation
end
