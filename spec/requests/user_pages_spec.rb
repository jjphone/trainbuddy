require 'spec_helper'

describe "User Pages" do
  subject	{ 	page }

  describe "signup pages" do
  	before	{ 	visit signup_path }
    it { 	should have_selector('h1', text: 'Sign up') }
  	it { 	should have_selector('title', text: site_title('Sign up') )}

    let(:submit) { "Sign up"}
    describe "with invalid info" do
      it "should not create user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      describe "after submission" do
        before { click_button submit }
        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
      end
    end

    describe "with valid info" do
      before do
        fill_in "Name",     with: "Test user"
        fill_in "Email",    with: "test@test.com"
        fill_in "Phone",    with: "1234567"
        fill_in "Login",    with: "test_user"
        fill_in "Password", with: "123456"
        fill_in "Retype Password", with: "123456"
      end
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('test@test.com') }
        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.flash.Success', text: 'successfully')}
        it { should have_link('Sign out')}
      end
    end
  end

  describe "profile page" do
  	let(:user) 	{ FactoryGirl.create(:user) }
  	before 		{ visit user_path(user) }
  	it { should have_selector('h1', text: user.name) }
  	it { should have_selector('title', text: user.name) }
  end

end
