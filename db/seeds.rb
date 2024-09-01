10.times do
  Table.create!(capacity: rand(1..10))
end

15.times do
  retries = 0
  begin
    days_in_future = rand(1..365)
    hours_in_future = rand(0..23)
    future_datetime = DateTime.now.beginning_of_hour + days_in_future + Rational(hours_in_future, 24)

    people_amount = rand(1..15)

    Reservations::Creator.new(time: future_datetime, people_amount: people_amount, name: "Seed").call
  rescue ArgumentError
    retries += 1
    retry if retries < 3
  end
end
