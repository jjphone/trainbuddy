# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mail do
    owner 1
    sender 1
    subj "MyString"
  end
end
