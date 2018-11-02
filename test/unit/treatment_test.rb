require 'test_helper'

class TreatmentTest < ActiveSupport::TestCase

  fixtures :treatments, :acts

  test "customer required" do
    t = treatments(:one)
    t.customer_id = nil
    assert t.invalid?
    assert t.errors[:customer_id].any?
  end

  test "customer correctly present" do
    t = treatments(:one)
    assert t.valid?
    assert !t.errors[:customer_id].any?
  end

  test "user required" do
    t = treatments(:one)
    t.user_id = nil
    assert t.invalid?
    assert t.errors[:user_id].any?
  end

  test "at least one service act required" do
    t = treatments(:no_acts)
    assert !t.acts.any?
    assert t.invalid?
    assert t.errors[:acts].any?
  end

  test "at least one service act correctly identified" do
    t = treatments(:one)
    assert t.acts.any?
    assert_equal t.acts.first.cost, 50.0
    assert t.valid?
  end

  test "date required" do
    t = treatments(:one)
    t.date = nil
    assert t.invalid?
    assert t.errors[:date].any?
  end

  test "commission must be between 0 and 1 (too low)" do
    t = treatments(:one)
    t.commission = -1
    assert t.invalid?
    assert t.errors[:commission].any?
  end

  test "commission must be between 0 and 1 (too high)" do
    t = treatments(:one)
    t.commission = 1.01
    assert t.invalid?
    assert t.errors[:commission].any?
  end

  test "commission is safely between 0 and 1" do
    t = treatments(:one)
    t.commission = 0.43
    assert t.valid?
    assert !t.errors[:commission].any?
  end

  test "tip cannot be negative" do
    t = treatments(:one)
    t.tip = -1
    assert t.invalid?
    assert t.errors[:tip].any?
  end

  test "tip can only have 2 significant digits" do
    t = treatments(:one)
    t.tip = 10.555
    assert t.invalid?
    assert t.errors[:tip].any?
  end

  test "tip has correct no. of digits" do
    t = treatments(:one)

    assert t.valid?, "#{t.tip.to_s.split('.')[1].length} digits found. " + t.errors[:tip].to_s
    assert !t.errors[:tip].any?
  end

end
