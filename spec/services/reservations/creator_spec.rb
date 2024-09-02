require 'rails_helper'

RSpec.describe Reservations::Creator, type: :service do
  let!(:table1) { create(:table, capacity: 4) }
  let!(:table2) { create(:table, capacity: 6) }
  let!(:table3) { create(:table, capacity: 8) }

  context 'when there is sufficient capacity' do
    it 'creates a reservation and assigns tables' do
      time = DateTime.now + 3.hours
      people_amount = 6
      name = "John Doe"
      
      expect_any_instance_of(Tables::Finder).to receive(:call).and_return([table2.id])
      
      service = described_class.new(time: time, people_amount: people_amount, name: name)
      reservation = service.call
      
      expect(reservation).to be_persisted
      expect(reservation.tables.pluck(:id)).to contain_exactly(table2.id)
      expect(reservation.name).to eq(name)
      expect(reservation.people_amount).to eq(people_amount)
      expect(reservation.time).to eq(time.beginning_of_hour)
    end
  end

  context 'when there is insufficient capacity' do
    it 'raises an ArgumentError' do
      time = DateTime.now
      people_amount = 15
      name = "John Doe"
      
      expect_any_instance_of(Tables::Finder).to receive(:call).and_return([])

      reservation = described_class.new(time: time, people_amount: people_amount, name: name).call
      expect(reservation.persisted?).to be_falsey
      expect(reservation.errors[:base]).to include("no capacity for selected time (#{time.beginning_of_hour}) and people amount (#{people_amount})")
    end
  end
end
