require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  fixtures :customers

  test "name required" do
    c = Customer.new
    assert c.invalid?
    assert c.errors[:name].any?
  end

  test "name too long" do
    long = "fifty" * 11
    c = Customer.new(name: long)
    assert c.invalid?
    assert c.errors[:name].any?
  end

  test "phone optional" do
    c = customers(:one)
    c.phone = nil
    assert c.valid?
    assert !c.errors[:phone].any?
  end

  test "phone optional, ignores blanks" do
    c = customers(:one)
    c.phone = ""
    assert c.valid?
    assert !c.errors[:phone].any?
  end

  test "phone format ok" do
    c = customers(:one)
    assert c.valid?
    assert !c.errors[:phone].any?
  end

  test "phone format corrected" do
    c = customers(:one)
    c.phone = "123-456-7899"
    c.save
    assert_equal c.phone, "1234567899"
    assert c.valid?
    assert !c.errors[:phone].any?
  end

  test "phone format bad" do
    c = customers(:one)
    c.phone = "123456789"
    assert c.invalid?
    assert c.errors[:phone].any?
  end

  test "email optional" do
    c = Customer.new(name: "whatever")
    assert c.valid?
    assert !c.errors[:email].any?
  end

end
