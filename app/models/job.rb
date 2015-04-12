class Job < ActiveRecord::Base
  belongs_to :organization
  belongs_to :template # Eventually HABTM maybe
  # belongs_to :batch # The associated batch

  validates_presence_of :cid, :name, :document_cid, :organization_id

  # Maps to Captricity Statuses
  STATUS = {
    setup:      "setup",        # Job is being configured.
    donttouch:   "donttouch",   # Job is being controlled by automated
                                #   processing, cannot be changed by user.
    uploading:  "uploading",    # Images are uploading.
    converting: "converting",   # A Batch is being converted to this job.
    reviewing:  "reviewing",    # Job is being reviewed by Captricity staff.
    pending:    "pending",      # Digitization is about to begin
    processing:   "processing", # Digitization has started.
    completed:  "completed",    # Digitization has finished
    canceled:   "canceled",     # Job has been canceled by Captricity staff
    paused:     "paused",       # Job has been paused by Captricity staff
    failed:     "failed",       # Job has entered a bad state and cannot make progress
    rerun:      "rerun",        # Job is about to be rerun with updated field definitions
    scheduled:  "scheduled",    # Schedules for digitization. 
  }

  def serializable_hash(options={})
    options = {
      :include => :template,
      :except => [
        :created_at, :updated_at
      ],
      :methods => []
    }.update(options)
    super(options)
  end
end
