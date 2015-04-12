class Organization < ActiveRecord::Base
  has_many :users
  has_many :jobs
  has_many :batches

  validates_presence_of :name
  validates_uniqueness_of :name
end
