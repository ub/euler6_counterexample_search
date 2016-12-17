FactoryGirl.define do
  factory :hypothesis do
    factor 1
    terms_count 4
    factory :hyp3 do
      terms_count 3
    end
    factory :hyp2 do
      terms_count 2
    end
  end
end
