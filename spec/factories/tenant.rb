FactoryBot.define do
  factory :tenant do
    name { FFaker::Company.name }
    api_key { '1234567890' }
    number_of_requests { 0 }
  end
end