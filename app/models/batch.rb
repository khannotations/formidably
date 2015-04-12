class Batch < ActiveRecord::Base
  belongs_to :organization
  belongs_to :template

  validates_presence_of :cid, :name

  def self.make_name(user, template_id)
    "#{user.organization.name}|t#{template_id}|#{Time.now.to_i}"
  end
end
