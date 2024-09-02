require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe 'validations' do
    subject { build(:reservation) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a time' do
      subject.time = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:time]).to include("can't be blank")
    end

    it 'is not valid without a people_amount' do
      subject.people_amount = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:people_amount]).to include("can't be blank")
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:name]).to include("can't be blank")
    end

    it 'is not valid with a people_amount less than or equal to 0' do
      subject.people_amount = 0
      expect(subject).to_not be_valid
      expect(subject.errors[:people_amount]).to include("must be greater than 0")
    end
  end

  describe 'custom validations' do
    context 'time_is_at_beginning_of_hour' do
      it 'adds an error if time is not at the beginning of the hour' do
        subject.time = DateTime.now.change(min: 15)
        expect(subject).to_not be_valid
        expect(subject.errors[:time]).to include("must be at the beginning of the hour")
      end
    end

    context 'time_is_in_supported_future' do
      it 'adds an error if time is in the past' do
        subject.time = DateTime.now - 1.day
        expect(subject).to_not be_valid
        expect(subject.errors[:time]).to include("must be in future and not more than #{Reservation::MAX_FUTURE_DAYS} days")
      end

      it 'adds an error if time is too far in the future' do
        subject.time = DateTime.now + (Reservation::MAX_FUTURE_DAYS + 1).days
        expect(subject).to_not be_valid
        expect(subject.errors[:time]).to include("must be in future and not more than #{Reservation::MAX_FUTURE_DAYS} days")
      end
    end
  end
end
