require 'spec_helper'

describe "Pages" do
  describe "Home page" do

    it "should have 'home' in content and title" do
		visit '/pages/home'
		page.should have_content('home')
		page.should have_selector('title', :text => 'Home')
    end


  end


  describe "Help page" do

    it "should have 'help' in the content and title" do
		visit '/pages/help'
		page.should have_content('help')
		page.should have_selector('title', :text => 'Help')
    end

  end


  describe "About page" do

    it "should have 'about' in the content and title" do
		visit '/pages/about'
		page.should have_content('about')
		page.should have_selector('title', :text => 'About')
    end

  end


end
