class Company < ActiveRecord::Base

  # Users have Companies, which have Services
  attr_accessible :name, :user_id, :main

  has_many :services, :dependent => :restrict
  belongs_to :user

  scope :main, where(main: true).limit(1)   # User has a default (main) Company

  def main_check
    "X" if main
  end

  def to_s
    name    
  end

  validates :user_id, presence: true  # No orphan companies
  validates :name, presence: true, length: { :maximum => 25 }, uniqueness: {scope: :user_id}
  validates :main, uniqueness: {scope: :user_id}

end
