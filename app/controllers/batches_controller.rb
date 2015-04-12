class BatchesController < ApplicationController
  respond_to :json
  before_action :authenticate_user!

  def index
    render json: current_user.organization.batches
  end

  def show
    render json: (current_user.organization.batches.findBy(params[:id]) || {})
  end

  def create
    template = Template.findBy(cid: params[:document_cid])
    # TODO: associate with Job
    unless template
      render json: {error: "No template found with cid #{params[:document_cied]}"},
        status: 400
    else
      @batch = Batch.new({
        cid: params[:id], # Turn ID parameter into Captricity ID
        name: params[:name],
        organization_id: current_user.organization_id
      })
      if @batch.save
        render json: @batch
      else
        render json: @batch.errors.full_messages, status: 400
      end
    end
  end

  private

  def batches_params
    params.permit(:cid, :name)
  end
end
