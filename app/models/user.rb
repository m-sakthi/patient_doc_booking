class User < ApplicationRecord
  # Associations
  has_one :inbox
  has_one :outbox
  has_many :payments
  has_many :messages

  # Scopes 
  scope :patient, -> { where(is_patient: true) }
  scope :admin, -> { where(is_admin: true) }
  scope :doctor, -> { where(is_doctor: true) }

  # Class methods
  def self.current
    User.patient.first
  end

  def self.default_admin
    User.admin.first
  end

  def self.default_doctor
    User.doctor.first
  end

  # Instance methods
  def full_name
    "#{first_name} #{last_name}"
  end
end
