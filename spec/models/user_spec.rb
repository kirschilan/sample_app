require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example", email: "example@example.com") }
  
  subject { @user }
  
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  
  it { should be_valid }
  
  require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
  
  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end
  
  require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
  
  describe "when email is not valie" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  
  describe "when name length is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when name length is too short" do
    before { @user.name = "aa" }
    it { should_not be_valid }
  end
  
  describe "when email address is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end
  
  describe "when email address is valid" do
    it "should be valid" do
      addresses = %w[user@foo.com A_U_SER@f.b.org first.last@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end
end
