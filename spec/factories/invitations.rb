# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    sender_id 1
    recipient_email "MyString"
    token "MyString"
    sent_at "2013-01-31 14:42:11"
    owner_id 1
  end
end
