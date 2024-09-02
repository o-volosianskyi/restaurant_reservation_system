class Reservations::Creator
  def initialize(time:, people_amount:, name:)
    @time = time.beginning_of_hour
    @people_amount = people_amount
    @name = name
  end

  def call
    table_ids = Tables::Finder.new(time: time, people_amount: people_amount).call

    ActiveRecord::Base.transaction do
      reservation = Reservation.new(
        name: name,
        time: time,
        people_amount: people_amount
      )

      if table_ids.empty?
        reservation.errors.add(:base, "no capacity for selected time (#{time}) and people amount (#{people_amount})")
        return reservation
      end
  
      reservation.tables = Table.where(id: table_ids)
      reservation.save

      reservation
    end
  end

  private
  attr_reader :time, :people_amount, :name
end
