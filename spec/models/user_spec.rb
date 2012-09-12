# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  login      :string(255)
#  email      :string(255)
#  phone      :string(255)
#  level      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do
  before do
  	@user = User.new(	name: "Example User", 	email: "user@example.com",	
  						password: "123456",	password_confirmation: "123456"
  					)
  end
  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:avatar)}

  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }

  it { should be_valid	}

  describe "user name" do
	  describe "when name is not present" do
	  	before { @user.name = " " }
	  	it { should_not be_valid }
	  end
  	  describe "when name is too long" do
  		before { @user.name = "a"*51 }
  		it { should_not be_valid }
  	  end
  end


  describe "user email" do
	  describe "when email is not present" do
	  	before { @user.email = " " }
	  	it { should_not be_valid }
	  end
	  describe "when email format is invaild" do
	  	it "should be invaild" do
	      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
	                     foo@bar_baz.com foo@bar+baz.com]
	      addresses.each do |invalid_address|
	        @user.email = invalid_address
	        @user.should_not be_valid
	      end
	  	end
  	  end

	  describe "when email format is valid" do
	    it "should be valid" do
	      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
	      addresses.each do |valid_address|
	        @user.email = valid_address
	        @user.should be_valid
	      end      
	    end
	  end

	  describe "when email address is already taken" do
	  	before do
	  		user_with_same_email = @user.dup	#duplicate user witn same attributes
	  		user_with_same_email.email = @user.email.upcase
	  		user_with_same_email.save
	  	end
	  	it { should_not be_valid }
	  end

	  describe "email with mixed cases" do
	  	let(:mixed_case_email) {"Aaa@AaaAa.Com"}
	  	it "should be saved to all lower-case" do
	  		@user.email = mixed_case_email
	  		@user.save
	  		@user.reload.email.should == mixed_case_email.downcase
	  	end
	  end

  end


  describe "basic password tests" do
	  describe "when password is not present" do
	  	before { @user.password = @user.password_confirmation = " "}
	  	it { should_not be_valid }
	  end

	  describe "when password NOT match confirmation" do
	  	before { @user.password_confirmation = "mismatch pwd_confirmation " }
	  	it { should_not be_valid }
	  end

	  describe "when password_confirmation is nil" do 
	  	before { @user.password_confirmation = nil }
	  	it { should_not be_valid }
	  end
  end


  describe "return value of authenticate method" do
  	before { @user.save }
  	let(:found_user) {User.find_by_email(@user.email) }

  	describe "with valid password" do
  		it { should == found_user.authenticate(@user.password) }
  	end

  	describe "with invalid password" do
  		let(:user_with_invalid_pwd) { found_user.authenticate("invalid") }
  		it { should_not == user_with_invalid_pwd }
  		specify { user_with_invalid_pwd.should be_false }
  	end

  	describe "with password too short" do
  		before {@user.password = @user.password_confirmation = "a"*5 }
  		it { should be_invalid }
  	end

  end

end
