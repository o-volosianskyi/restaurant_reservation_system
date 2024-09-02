class Reservation < ApplicationRecord
  has_many :reservation_tables, dependent: :destroy
  has_many :tables, through: :reservation_tables

  MAX_FUTURE_DAYS = 365

  validates :time, presence: true
  validate :time_is_at_beginning_of_hour
  validate :time_is_in_supported_future

  validates :people_amount, { presence: true, numericality: { greater_than: 0 } }
  validates :name, presence: true

  private

  def time_is_at_beginning_of_hour
    if time.present? && (time.min != 0 || time.sec != 0)
      errors.add(:time, "must be at the beginning of the hour")
    end
  end

  def time_is_in_supported_future
    if time.present? && (!time.future? || (time.to_date - Date.today).to_i > MAX_FUTURE_DAYS)
      errors.add(:time, "must be in future and not more than #{MAX_FUTURE_DAYS} days")
    end
  end
end
