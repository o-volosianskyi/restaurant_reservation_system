10.times do
  capacity = rand(2..8)
  Table.create!(capacity: capacity)
  puts "Created a table with capacity: #{capacity}"
end

15.times do
  retries = 0
  begin
    future_datetime = Faker::Time.between(from: DateTime.now + 1.day, to: DateTime.now + Reservation::MAX_FUTURE_DAYS).beginning_of_hour

    people_amount = rand(1..15)

    Reservations::Creator.new(time: future_datetime, people_amount: people_amount, name: Faker::Name.name).call
  rescue ArgumentError
    retries += 1
    retry if retries < 3
  end
end
