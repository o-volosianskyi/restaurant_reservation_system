FactoryBot.define do
  factory :table do
    capacity { rand(2..8) }
  end
end
