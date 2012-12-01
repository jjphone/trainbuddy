# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    user_id 1
    status 1
    parent_id 1
    content "MyString"
  end
end
