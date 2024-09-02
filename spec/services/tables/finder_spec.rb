require 'rails_helper'

describe Tables::Finder do
  let!(:table1) { create(:table, capacity: 4) }
  let!(:table2) { create(:table, capacity: 5) }
  let!(:table3) { create(:table, capacity: 8) }
  let!(:table4) { create(:table, capacity: 10) }

  context 'when an exact match is found' do
    it 'returns the table with exact capacity' do
      finder = described_class.new(time: DateTime.now, people_amount: 5)
      result = finder.call
      expect(result).to contain_exactly(table2.id)
    end
  end

  context 'when a closest match is found' do
    it 'returns the closest matching table' do
      finder = described_class.new(time: DateTime.now, people_amount: 7)
      result = finder.call
      expect(result).to contain_exactly(table3.id)
    end
  end

  context 'when multiple tables are needed' do
    it 'returns multiple tables that together satisfy the people amount' do
      finder = described_class.new(time: DateTime.now, people_amount: 14)
      result = finder.call
      expect(result).to contain_exactly(table1.id, table4.id)
    end
  end

  context 'when no suitable tables are found' do
    it 'returns an empty array' do
      finder = described_class.new(time: DateTime.now, people_amount: 30)
      result = finder.call
      expect(result).to be_empty
    end
  end

  context 'when tables are reserved' do
    let!(:reserved_table) { create(:table, capacity: 5) }
    let!(:reservation) { create(:reservation, time: DateTime.now.beginning_of_hour + 1.hour, people_amount: 6, tables: [reserved_table]) }

    it 'does not include reserved tables' do
      finder = described_class.new(time: DateTime.now + 1.hour, people_amount: 5)
      result = finder.call
      expect(result).to contain_exactly(table2.id)
    end
  end

  context 'when tables with allowed max wasted seats are present' do
    let!(:free_table) { create(:table, capacity: 14) }
    let!(:reserved_table) { create(:table, capacity: 12) }
    let!(:reservation) { create(:reservation, time: DateTime.now.beginning_of_hour + 1.hour, people_amount: 11, tables: [reserved_table]) }

    it 'does not include reserved tables' do
      finder = described_class.new(time: DateTime.now + 1.hour, people_amount: 12)
      result = finder.call
      expect(result).to contain_exactly(free_table.id)
    end
  end
end
