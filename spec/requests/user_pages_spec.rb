require 'spec_helper'

describe "User Pages" do
  subject	{ 	page }

  shared_examples_for "page with title and H1 header" do
    it { should have_selector('title', text: page_title) }
    it { should have_selector('h1', text: h1_content)}
  end


  describe "signup pages" do
  	before	{ 	visit signup_path }
    let(:page_title)      { site_title('Sign up') }
    let(:h1_content)      { 'Sign up' }
    it_should_behave_like "page with title and H1 header"

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
    let(:page_title)      { user.name }
    let(:h1_content) { user.name }
    it_should_behave_like "page with title and H1 header"
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end


    describe "page" do
      let(:page_title)      { 'Edit user' }
      let(:h1_content)      { 'Edit user'}
      it { should have_selector('input', name: "avatar") }
      it_should_behave_like "page with title and H1 header"
    end

    describe "with invalid info" do
      before { click_button "Update" }
      it { should have_content('error') }
    end

    describe "with vaild info" do
      let(:new_name)  { "new name" }
      let(:new_email) { "new@new.com" }
      before do
        fill_in "Name",           with: new_name
        fill_in "Email",          with: new_email
        fill_in "Password",       with: user.password
        fill_in "Retype Password", with: user.password
        click_button "Update"
      end
      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.flash.Success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end
  end

  describe "index" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "index2", email: "index2@u.com")
      FactoryGirl.create(:user, name: "index3", email: "index3@u.com")
      visit users_path
      
    end
    after (:all)    {User.delete_all}
    let(:page_title)      { site_title('List users') }
    let(:h1_content)      { 'User list' }
    it_should_behave_like "page with title and H1 header"

    it { should have_selector('input', name: 'search') }
    it { should have_button('search') }




#     describe "pageination" do
#       before(:all) do
#         visit users_path
#         fill_in "Email",          with:   "u.com"
#         click_button 'search'
#       end

#       after (:all)    { User.delete.all }
#       it { should have_selector('title', text: site_title('List users')) }
#       # click_button 'search'

# #      it { should have_selector('div.pageination') }

#       it "should list each user" do
#         User.pageinate(page: 1).each do |user|
#           page.should have_selector('li', text: user.name)
#         end
#       end
#    end

    


  end


end
