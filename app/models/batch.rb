class Batch < ActiveRecord::Base
  belongs_to :organization
  belongs_to :template
  # has_one :job # The associated job, if any

  validates_presence_of :cid, :name

  # Maps to Captricity Statuses
  STATUS = {
    setup:      "setup",              # batch is being set up.
    processing: "processing",         # batch has been submitted for processing.
    converting: "converting-to-job",  # batch is being converted to a job.
    sorting:    "sorting",            # batch is being sorted.
    processed:  "processed",          # batch has been processed.
    rejected:   "rejected"            # batch has been rejected.
  }

  def self.make_name(user, template_id)
    "#{user.organization.name}|t#{template_id}|#{Time.now.to_i}"
  end
end
