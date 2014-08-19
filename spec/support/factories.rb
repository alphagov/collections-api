FactoryGirl.define do
  factory :user do
    permission { ["signin"] }
  end
end
