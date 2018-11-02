require 'test_helper'

class ServiceTest < ActiveSupport::TestCase

  fixtures :services, :companies

  test "name required" do
    s = services(:one)
    s.name = nil
    assert s.invalid?
    assert s.errors[:name].any?
    
    s.name = ""
    assert s.invalid?
    assert s.errors[:name].any?
  end

  test "name too long" do
    long = "fifty" * 11
    s = services(:one)
    s.name = long
    assert s.invalid?
    assert s.errors[:name].any?
  end

  test "name has ok length" do
    s = services(:one)
    s.name = "forty" * 8
    assert s.valid?
    assert !s.errors[:name].any?
  end

  test "no duplicate service names within a company" do
    s = services(:one)
    s.name = 'MyString3'
    assert s.invalid?
    assert s.errors[:name].any?
  end

  test "price required" do
    s = services(:one)
    s.price = nil
    assert s.invalid?
    assert s.errors[:price].any?
  end

  test "price must be nonnegative" do
    s = services(:one)
    s.price = -1
    assert s.invalid?
    assert s.errors[:price].any?
  end

  test "price can only have 2 significant digits" do
    s = services(:one)
    s.price = 10.555
    assert s.invalid?
    assert s.errors[:price].any?
  end

  test "price has correct no. of digits" do
    s = services(:one)

    assert s.valid?, "#{s.price.to_s.split('.')[1].length} digits found. " + s.errors[:price].to_s
    assert !s.errors[:price].any?
  end

  test "company required" do
    s = services(:one)
    s.company_id = nil
    assert s.invalid?
    assert s.errors[:company_id].any?
  end

end
