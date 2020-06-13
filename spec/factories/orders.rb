FactoryBot.define do
  factory :order do
    payu_order_id { "MyString" }
    payment_status { "MyString" }
    details { "" }
  end
end
