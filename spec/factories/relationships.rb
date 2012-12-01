# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :relationship do
    user_id 1
    friend_id 1
    status 1
  end
end
