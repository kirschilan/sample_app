require 'spec_helper'

describe User do
  before do 
    @user = User.new(name: "Example", email: "example@example.com")
    @user.password = "123456"
    @user.password_confirmation = "123456"
  end
  
  subject { @user }
  
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest)}
  it { should respond_to(:password)}
  it { should respond_to(:password_confirmation)}
  
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
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com foo@bar..com foo@bar.com.]
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
  
  describe "when email address is duplicate" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
    end
    
    it {should_not be_valid }
  end

  describe "when case-sensitive email address is duplicate" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    
    it {should_not be_valid }
  end
  
  describe "when email is mixed case" do
    before do
      @user_with_mixed_case_email = @user.dup
      @mixed_case_email = "ExamPlE@ExamplE.CoM"
      @user_with_mixed_case_email.email = @mixed_case_email
    end
    
    it "should be saved as all lowercase" do
      @user_with_mixed_case_email.save
      expect(@user_with_mixed_case_email.reload.email).to eq @mixed_case_email.downcase
    end 
  end
  
  describe "when password is not present" do
    before do
      @user = User.new(name: "test password", email: "password@example.com") 
      @user.password              = " "
      @user.password_confirmation = " "
    end
    it { should_not be_valid }
  end
  
  describe "when password does not match confirmatio" do
    before { @user.password = "mismatch" }
    it { should_not be_valid }
  end
  
  it { should respond_to :authenticate }
  
  describe "password should not be shorter than 5 characters" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }
    
    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end
    
    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end
end
