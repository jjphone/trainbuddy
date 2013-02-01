require 'spec_helper'

describe ApplicationHelper do 
	describe "full_title" do
		it "should include the page title" do
			site_title("foo").should =~ /foo/
		end

		it "should include the base title" do
			site_title("foo").should =~ /^Trainbuddy/

		end

		it "should not include a bar for home page" do
			site_title("").should_not =~ /\|/
		end

	end
end