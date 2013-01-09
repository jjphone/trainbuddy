FactoryGirl.define do
  factory :user do
  	sequence(:name) 		{ |n| "user #{n}" }
  	sequence(:email)		{ |n| "u#{n}@u.com" }
    password "123456"
    password_confirmation "123456"
    
  end
  factory :micropost do
  	content	"factory micropost content"
  	user
  end


end
