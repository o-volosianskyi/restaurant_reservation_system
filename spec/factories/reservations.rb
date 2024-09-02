FactoryBot.define do
  factory :reservation do
    time { Faker::Time.between(from: DateTime.now + 1.day, to: DateTime.now + Reservation::MAX_FUTURE_DAYS) }
    people_amount { rand(1..6) }
    name { Faker::Name.name }

    after(:create) do |reservation|
      table = create(:table, capacity: reservation.people_amount)
      reservation.tables << table
    end
  end
end
