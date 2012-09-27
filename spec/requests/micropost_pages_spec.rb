require 'spec_helper'

describe "MicropostPages" do
subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "send" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "send" }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do
      before { fill_in 'post_text', with: "Lorem ipsum" }

      it "should create a micropost" do
        expect { click_button "send" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before  { visit root_path }

      it "should delete micropost" do 
        expect { click_link "x" }.to change(Micropost, :count).by(-1)
      end
    end

  end

end