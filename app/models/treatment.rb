class Treatment < ActiveRecord::Base

  # A single visit by a single Customer with 1+ Acts, which are chosen from company Services

  attr_accessible :commission, :customer_id, :date, :service_id, :user_id, 
    :tip, :comment, :acts_attributes

  self.per_page = 20

  belongs_to :customer
  belongs_to :user
  has_many :acts
  has_many :services, through: :acts

  # Create 1+ Acts from within the Treatment form while also creting the overall Treatment
  # Ignore/reject blank row forms without raising exceptions
  accepts_nested_attributes_for :acts,
    :reject_if => lambda { |attrs| attrs.any? { |key, val| val.blank? } },
    :allow_destroy => true

  validates :customer_id, presence: true #TODO: fix tech issues with requiring.
  validates :user_id, presence: true
  validates :acts, :presence => { message: "must include at least one service" }
  validates :date, presence: true
  validates :tip, cents: true
  validates :tip, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :commission, presence: true, 
    numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1}

  # Multiple Acts and their costs add up to a Treatment
  def cost
    acts.sum(:cost)
  end

  def commission_earned
    cost * commission
  end

  def total_earned
    commission_earned + tip
  end

  # List Treatments after specified date
  def self.after(date)
    where('date >= ?', date)
  end

  # List Treatments before specified date
  def self.before(date)
    where('date <= ?', date)
  end

  # List Treatments on specified date
  def self.dated(date)
    where('date = ?', date)
  end

  # List Treatments between specified dates
  def self.between(date1, date2)  #inclusive
    where('date >= ? and date <= ?', date1, date2)
  end

  # List Treatments during specified week no.
  def self.during_week(week_no)   
    d = PayPeriod.weekly_dates(week_no)  # Will need dates to process
    between(d[0][1],d[0][2])
  end

  # Treatments that fall within the current week
  def self.current_week
    after(PayPeriod.first_date(nil,7))
  end

  # Treatments that fall within the current pay period
  def self.current_period
    after(PayPeriod.first_date)
  end

  # Shortcut to the pay period no.
  def pay_period
    PayPeriod.period(date)
  end

  # Shortcut to the week no.
  def week
    PayPeriod.period(date, 7)
  end

  # To build a Treatment form that contains to subordinate Acts
  def with_acts(n=1)
    n.times { acts.build }
    self
  end

  # Check if cost of this week's treatments exceeds weekly goals 
  # to trigger higher commission
  # Return boolean
  def met_goals?
    treatments_for_week = self.user.treatments.during_week(self.week)
    costs = treatments_for_week.sum(&:cost)   
    costs >= self.user.goal
  end

  # If met sales goals, use higher commission, else default commission
  def correct_commission
    met_goals? ? self.user.high_commission : self.user.commission_rate
  end

end
