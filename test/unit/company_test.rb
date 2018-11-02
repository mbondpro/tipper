# ruby -Itest test/unit/company_test.rb

require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  fixtures :companies

  test "user required" do
    c = companies(:one)
    c.user_id = nil
    assert c.invalid?
    assert c.errors[:user_id].any?
  end

  test "name required" do
    c = Company.new
    assert c.invalid?
    assert c.errors[:name].any?
  end

  test "name too long" do
    long = "fifty" * 10
    c = Company.new(name: long)
    assert c.invalid?
    assert c.errors[:name].any?
  end

  test "unique name per user" do
    c = Company.new(name: "MyString", user_id: 1)
    assert c.invalid?
    assert c.errors[:name].any?
  end

  test "only one main company per user" do
    c = Company.new(name: "comp", user_id: 1, main: true)
    assert c.invalid?, "Validated having only one main co. per user"
    assert c.errors[:main].any?, "Validated having more than one main co. per user, main error."
  end

  test "only one main company per user. passes" do
    c = Company.new(name: "comp2", user_id: 1, main: false)
    assert c.valid?, c.errors.full_messages.inspect 
    assert !c.errors[:main].any?, "Invalidated having more than one main co. per user, main error."
  end

  test "main check returns X" do    
    assert_equal companies(:one).main_check, "X"  #main
    assert_equal companies(:two).main_check, nil  #not main
  end

end
