class PayPeriod

  # Used to define a pay period for reports. 

  FIRST_PERIOD = Date.new(2018,9,12)  # TODO: Should be based on User's registration date
  PERIOD_LENGTH = 14  # TODO: Should be user-configurable

  # What is period number of the current period?
  def self.current(period_length = nil)
    period(Date.today, period_length)
  end

  # Returns the index of the period in question, e.g., Pay Period #7 since starting service
  def self.period(date = nil, period_length = nil)
    (to_d(date || Date.today) - FIRST_PERIOD).to_int / (period_length || PERIOD_LENGTH) + 1
  end

  # Show start date of the period in question
  def self.first_date(period_no = nil, period_length = nil)
    period_no = period(Date.today, period_length) if period_no.nil?
    FIRST_PERIOD + ((period_no - 1) * (period_length || PERIOD_LENGTH))
  end

  # Show end date of the period in question
  def self.last_date(period_no = nil, period_length = nil)
    p_len = period_length || PERIOD_LENGTH
    first_date(period_no || period(Date.today), p_len) + p_len - 1
  end

  # 2D array of start-stop for all periods
  def self.period_dates(from = 1, to = current)
    (from..to).map {|p| [p, PayPeriod.first_date(p), PayPeriod.last_date(p)]}
  end

  # Show the start and end dates of each period
  def self.weekly_dates(from = 1, to = current(7))
    (from..to).map {|p| [p, PayPeriod.first_date(p, 7), PayPeriod.last_date(p, 7)]}
  end

  def self.to_d(date)
    date.is_a?(String) ? Date.parse(date) : date
  end

  # return array containing each date in the current period
  def self.each_date(first_d = first_date, last_d = Date.today)
    a = []
    (first_d..last_d).each {|x| a << x }
    a
  end

end
