class Act < ActiveRecord::Base
  # An instantiation of a Service during a Treatment. One or more Acts per Treatment.

  belongs_to :service
  belongs_to :treatment
  attr_accessible :cost, :service_id, :treatment_id

#  validates :service_id, presence: true
  validates :cost, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :cost, cents: true

end
