# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :plan do
    user_id 1
    loc "MyString"
    time "MyString"
    subj "MyString"
    mate "MyString"
  end
end
