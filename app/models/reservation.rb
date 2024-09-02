class Reservation < ApplicationRecord
  has_many :reservation_tables
  has_many :tables, through: :reservation_tables

  MAX_FUTURE_DAYS = 365

  validate :time_is_at_beginning_of_hour
  validate :time_is_in_supported_future

  private

  def time_is_at_beginning_of_hour
    if time.present? && (time.min != 0 || time.sec != 0)
      errors.add(:time, "must be at the beginning of the hour")
    end
  end

  def time_is_in_supported_future
    if !time.future? || (Time.zone.now - time).days > MAX_FUTURE_DAYS
      errors.add(:time, "must be in future and not more than #{MAX_FUTURE_DAYS} days")
    end
  end
end
