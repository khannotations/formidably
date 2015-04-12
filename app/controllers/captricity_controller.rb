# require 'captricity/api'

# class CaptricityController < ApplicationController
#   include Captricity

#   before_action :authenticate_user!

#   @@captricity = Captricity::API.new

#   def dashboard 
#     @user = current_user
#     @org = @user.organization
#     @org_job_ids = @org.jobs.pluck(:cid)
#     @jobs = @@captricity.get_jobs
#     if @jobs.is_a? Array
#       @jobs = @jobs.select { |j| @org_job_ids.include? j["id"] }
#     else
#       @jobs = []
#       puts "Error" # Throw some error
#     end
#   end

#   def upload
#     @templates = Template.where(active: true, deleted: false)
#   end

#   def get_batch
#     @batch = @@captricity.get_batch(params[:id])
#     @files = @@captricity.get_batch_files(params[:id])
#     @file_url_base = "https://shreddr.captricity.com/api/v1/batch-file/"
#   end

#   def create_batch
#     tid = params[:template_id]
#     unless tid.blank?
#       # Todo: put this in Batch model
#       batch = @@captricity.create_batch(Batch.make_name(current_user, tid), 
#         documents: [tid.to_i])
#       render json: batch
#     else
#       render json: {error: "Template can't be blank"}, status: 400
#     end
#   end

#   def upload_files
#     batch_id = params[:batch_id]
#     unless batch_id.blank?
#       # byebug
#       uploaded_io = params[:uploadfiles].first
#       file_path = Rails.root.join('public', 'uploads', "#{rand(1000)}" +
#         uploaded_io.original_filename)
#       File.open(file_path, 'wb') do |file|
#         file.write(uploaded_io.read)
#       end
#       response = @@captricity.upload_file(batch_id, uploaded_io.tempfile.path,
#         uploaded_file_name: uploaded_io.original_filename)
#       render json: response
#     else
#       render json: {error: "Batch ID can't be blank"}, status: 400
#     end
#     # redirect_to '/batch/' + params[:id]
#   end

#   private
# end
