class JobsController < ApplicationController
  respond_to :json
  before_action :authenticate_user!

  def index
    render json: current_user.organization.jobs
  end

  def show
    render json: (current_user.organization.jobs.findBy(params[:id]) || {})
  end

  def create
    @job = Job.new(job_params.merge({organization_id: current_user.organization_id}))
    if @job.save
      render json: @job
      # Associate with template
      @template = Template.find_by(cid: params[:document_cid])
      @job.update_attribute(:template_id, @template.id) if @template
    else
      render json: @job.errors.full_messages, status: 400
    end
  end

  def update
    @job = Job.find(params[:id])
    @job.update_attributes(job_params)
    render json: @job
  end

  private

  def job_params
    params.permit(:cid, :name, :created, :started, :document_cid, :status)
  end
end
