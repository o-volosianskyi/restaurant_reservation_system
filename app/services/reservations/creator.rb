class Reservations::Creator
  MAX_WASTED_SEATS = 2

  def initialize(time:, people_amount:, name:)
    @time = time.beginning_of_hour
    @people_amount = people_amount
    @name = name
  end

  def call
    table_ids = find_suitable_table_ids(time, people_amount)
    raise ArgumentError, "no capacity for selected time (#{time}) and people amount (#{people_amount})" if table_ids.empty?

    ActiveRecord::Base.transaction do
      reservation = Reservation.create!(
        name: name,
        time: time,
        people_amount: people_amount
      )
  
      reservation.tables = Table.find(table_ids)
    end
  end

  private 
  attr_reader :time, :people_amount, :name

  def find_suitable_table_ids(time, people_amount, tables = nil)
    tables ||= Table.left_joins(reservation_tables: :reservation)
                    .where('reservations.time IS NULL OR reservations.time <> ?', time)
                    .order(capacity: :desc)
                    .as_json
                    .map(&:symbolize_keys)
  
    return [] if tables.empty?
  
    exact_or_closest_match = tables.sort_by { |t| t[:capacity] }.find { |t| t[:capacity] >= people_amount && t[:capacity] <= people_amount + MAX_WASTED_SEATS }
  
    if exact_or_closest_match
      return [exact_or_closest_match[:id]]
    else
      best_fit = tables.find { |t| t[:capacity] <= people_amount }
      
      if best_fit
        remaining_people = people_amount - best_fit[:capacity]
        remaining_tables = tables.reject { |t| t[:id] == best_fit[:id] }
  
        return [best_fit[:id]] + find_suitable_table_ids(time, remaining_people, remaining_tables)
      else
        return []
      end
    end
  end
end
