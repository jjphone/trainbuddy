require 'spec_helper'

describe "Pages" do
  subject { page }

  shared_examples_for "pages in Page_controller" do
    it {  should have_selector('h1', text: heading) }
    it {  should have_selector('title', text: site_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)     {   'Home' } 
    let(:page_title)  {  '' }

    it_should_behave_like "pages in Page_controller"
    it {  should_not have_selector('title', text: site_title('Home') ) }
  end


  describe "Help page" do
    before {  visit help_path }
    let(:heading)     {   'Help' } 
    let(:page_title)  {   'Help' } 

    it_should_behave_like "pages in Page_controller"
  end


  describe "About page" do
    before {  visit about_path }
    let(:heading)     {   'About' } 
    let(:page_title)  {   'About' } 

    it_should_behave_like "pages in Page_controller"
  end

  describe "Contact page" do
    before {  visit contact_path }
    let(:heading)     {   'Contact' } 
    let(:page_title)  {   'Contact' } 

    it_should_behave_like "pages in Page_controller"
  end

  it "should have the right links on layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: site_title('About')
    click_link "Help"
    page.should have_selector 'title', text: site_title('Help')
    click_link "Contact Us"
    page.should have_selector 'title', text: site_title('Contact')
    click_link "Home"
    page.should have_selector 'title', text: site_title('')
  end


end
