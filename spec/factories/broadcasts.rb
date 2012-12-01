# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :broadcast do
    user_id 1
    status 1
    ref_msg 1
    msg_content "MyString"
    string "MyString"
  end
end
