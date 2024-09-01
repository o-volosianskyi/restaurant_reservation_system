class Reservation < ApplicationRecord
  has_many :reservation_tables
  has_many :tables, through: :reservation_tables

  validate :time_is_at_beginning_of_hour_and_future

  private

  def time_is_at_beginning_of_hour_and_future
    if time.present? && (time.min != 0 || time.sec != 0)
      errors.add(:time, "must be at the beginning of the hour")
    end

    if !time.future?
      errors.add(:time, "must be in future")
    end
  end
end
