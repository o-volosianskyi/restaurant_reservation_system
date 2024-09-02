class Reservations::Creator
  def initialize(time:, people_amount:, name:)
    @time = time.beginning_of_hour
    @people_amount = people_amount
    @name = name
  end

  def call
    table_ids = Tables::Finder.new(time: time, people_amount: people_amount).call
    raise ArgumentError, "no capacity for selected time (#{time}) and people amount (#{people_amount})" if table_ids.empty?

    ActiveRecord::Base.transaction do
      reservation = Reservation.create!(
        name: name,
        time: time,
        people_amount: people_amount
      )
  
      reservation.tables = Table.where(id: table_ids)

      reservation
    end
  end

  private
  attr_reader :time, :people_amount, :name
end
