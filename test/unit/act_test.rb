require 'test_helper'

class ActTest < ActiveSupport::TestCase

  fixtures :acts

  test "service_id must exist" do
    obj = acts(:one)
    obj.service_id = nil
    assert obj.invalid?
    assert obj.errors[:service_id].any?
  end

  test "cost cannot be negative" do
    obj = acts(:one)
    obj.cost = -1
    assert obj.invalid?
    assert obj.errors[:cost].any?
  end

  test "cost can only have 2 significant digits" do
    obj = acts(:one)
    obj.cost = 10.555
    assert obj.invalid?
    assert obj.errors[:cost].any?
  end

  test "cost has correct no. of digits" do
    obj = acts(:one)

    assert obj.valid?, "#{obj.cost.to_s.split('.')[1].length} digits found. " + obj.errors[:cost].to_s
    assert !obj.errors[:cost].any?
  end
end
