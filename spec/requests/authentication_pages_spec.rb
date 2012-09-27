require 'spec_helper'

describe "Authentication" do
	subject { page }

	shared_examples_for "signin" do
		it { should have_selector('title', text: page_title) }
		it { should have_selector(add_selector, text: add_select_text)	}
	end

   describe "signin page" do
      before { visit signin_path }
      it { should have_selector('h1', text: 'Sign in') }
      it { should have_selector('h1', text: 'Sign in') }

   	describe "with invalid info" do
   		let(:page_title)	{ 'Sign in'}
   		let(:add_selector) 	{ 'div.flash.Error' } 

   		describe "case: password < 6" do
   		  before  do
             fill_in "Email",	with: 'non_existing@email_non_existing.com'
   		    fill_in "Password",	with: ' '
   		    click_button "Sign in"
   		  end
           let(:add_select_text) 	{ 'required' }
   		  it_should_behave_like "signin"

   		  describe "after visit another page" do
   		    before { click_link "Home" }
   		    it { should_not have_selector('div.flash.Error') }
   		  end
   	   end

   		describe "case: invaild email" do
   		  before do
   		    fill_in "Email",	with: 'non_existing@email_non_existing.com'
   		    fill_in "Password",	with: 'dummy_password'
   		    click_button "Sign in"
   		  end
   		  let(:add_select_text) 	{ 'Invalid' }
   		  it_should_behave_like "signin"
   		end

   		describe "case: invalid password" do
   			let(:user) { FactoryGirl.create(:user) }

   			let(:page_title)	{ 'Sign in'}
   			let(:add_selector) 	{ 'div.flash.Error' }  
   			before do
   				fill_in "Email", 	with: user.email
   				fill_in "Password", with: 'dummy_password'
   				click_button 'Sign in'
   			end
   			let(:add_select_text) 	{ 'Invalid' }
   		  	it_should_behave_like "signin"
   		end
   	end


   	describe "with vaild info" do
   		let(:user) { FactoryGirl.create(:user) }
   		before { sign_in(user) }

   		it { should 	have_selector('title', text: site_title('Home')) }
   		it { should 	have_link('Profile', href: user_path(user)) }
         it { should    have_link('Edit', href: edit_user_path(user)) }
   		it { should 	have_link('Sign out', href: signout_path) }
   		it { should_not have_selector('Sign in', href: signin_path) }

         describe "followed by signout" do
            before { click_link "Sign out" }
            it { should have_link('Sign in') }
         end
   	end
   end

   describe "authentication" do
      describe "for non-signed-in users" do
         let(:user)     { FactoryGirl.create(:user) }

         describe "in the User controller" do
            describe "visiting the edit page" do
               before { visit edit_user_path(user) }
               it { should have_selector('title', text: 'Sign in')}

               describe "visiting the user index" do
                  before   { visit users_path }
                  it { should have_selector('title', text: 'Sign in')}
               end

            end

            describe "submitting to the update action" do
               before { put user_path(user) }  # issue PUT http request
               specify { response.should redirect_to(signin_path) }
            end
         end

         describe "when attempting to visit a protected page" do
            before do
               visit edit_user_path(user)
               fill_in "Email",     with: user.email
               fill_in "Password",  with: user.password
               click_button "Sign in"
            end
            describe "after signing in" do
               it "should render the desired protected page" do
                  page.should have_selector('title', text: 'Edit user')
               end
            end
         end

         describe "in the Microposts controller" do
            describe "submitting to the create action" do
               before   {  post microposts_path }
               specify  {  response.should redirect_to(signin_path) }
            end
            describe "submitting to the destroy action" do
               before   {  delete micropost_path(FactoryGirl.create(:micropost)) }
               specify  {  response.should redirect_to(signin_path) }
            end
         end

      end

      describe "as wrong user" do
         let(:user)        { FactoryGirl.create(:user) }
         let(:wrong_user)  { FactoryGirl.create(:user, email: "wrong@email.com") }
         before            { sign_in user }

         describe "visiting Users#edit page" do
            before         { visit edit_user_path(wrong_user) }
            it { should_not have_selector('title', text: site_title('Edit user')) }
         end

         describe "submitting a PUT request to the Users#update action" do
            before         { put user_path(wrong_user) }
            specify        { response.should redirect_to(root_path) }
         end

      end

   end

end
