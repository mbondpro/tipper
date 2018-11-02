class Service < ActiveRecord::Base

  # A company's service menu item. Selected & instantiated as individual Acts during each Treatment.

  attr_accessible :name, :price, :company_id

  has_many :treatments, through: :acts
  has_many :acts
  belongs_to :company

  scope :by_co, order('companies.main DESC')

  default_scope order('name ASC')

  validates :name, presence: true, length: {maximum: 50}, uniqueness: { scope: :company_id }
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :price, cents: true
  validates :company_id, presence: true

  def to_s
    name
  end

end
