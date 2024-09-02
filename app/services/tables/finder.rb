class Tables::Finder
  MAX_WASTED_SEATS = 2

  def initialize(time:, people_amount:)
    @time = time.beginning_of_hour
    @people_amount = people_amount
  end

  def call
    find_suitable_table_ids(time, people_amount)
  end

  private

  attr_reader :time, :people_amount

  def find_suitable_table_ids(time, people_amount, tables = nil)
    tables ||= Table.left_joins(reservation_tables: :reservation)
                    .where('reservations.time IS NULL OR reservations.time <> ?', time)
                    .order(capacity: :desc)
                    .as_json
                    .map(&:symbolize_keys)

    return [] if tables.empty?

    exact_or_closest_match = tables.sort_by { |t| t[:capacity] }
                                   .find { |t| t[:capacity] >= people_amount && t[:capacity] <= people_amount + MAX_WASTED_SEATS }

    if exact_or_closest_match
      return [exact_or_closest_match[:id]]
    else
      best_fit = tables.find { |t| t[:capacity] <= people_amount }

      if best_fit
        remaining_people = people_amount - best_fit[:capacity]
        remaining_tables = tables.reject { |t| t[:id] == best_fit[:id] }

        result = find_suitable_table_ids(time, remaining_people, remaining_tables)

        return [] if remaining_people > 0 && result.empty?

        return [best_fit[:id]] + result
      else
        return []
      end
    end
  end
end
