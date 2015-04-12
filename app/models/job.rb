class Job < ActiveRecord::Base
  belongs_to :organization
  belongs_to :template # Eventually HABTM maybe

  validates_presence_of :cid, :name
end
