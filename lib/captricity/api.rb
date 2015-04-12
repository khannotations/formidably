# A Ruby class for communicating with the Captricity API.
# API documentation is at https://shreddr.captricity.com/developer/api-reference
module Captricity
  class API
    include RestClient
    BASE_URL = "https://shreddr.captricity.com/api/v1/"
    JOB_CALLBACK = ""

    def initialize(api_key="cb870e6253ce41a8b96b706a2bd0278e")
      @client = RestClient::Resource.new BASE_URL, headers: {
        "Captricity-API-Token" => api_key
      }
    end

    # Get all the user's batches.
    # @return{hash} Response hash.
    def get_batches
      get_request "batch/"
    end

    # Get the specified batch.
    # @param{number|string} id The batch ID.
    # @return{hash} Response hash.
    def get_batch(id)
      get_request "batch/" + id.to_s
    end

    # Create a batch with sensible defaults.
    # @param{string} name The name of the batch.
    # @param{hash} params The params hash.
    #   sorting_enabled: boolean
    #   is_sorting_only: boolean
    #   documents: (Array<integer>) an array of document ids
    #   schemas: ?
    # @return{hash} Response hash.
    def create_batch(name, params={})
      post_request "batch/", {
        name: name,
        sorting_enabled: params[:sorting_enabled] || true,
        is_sorting_only: params[:is_sorting_only] || true,
        documents: [],
        schemas: []
      }
    end

    def delete_batch(id)
      delete_request "batch/#{id}"
    end

    # Get all the files associated with a batch.
    # @param{number|string} batch_id The batch ID.
    # @return{hash} Response hash.
    def get_batch_files(batch_id)
      get_request "batch/#{batch_id}/batch-file/"
    end

    # Upload a file to a given batch.
    # @param{number|string} batch_id The batch ID.
    # @param{File|string} file_handle Either a file object, or path to the file.
    # @return{hash} Response hash.
    def upload_file(batch_id, file_handle="./test.pdf", params={})
      if file_handle.is_a? File
        file = file_handle
      else
        file = File.new(file_handle)
      end
      file_name = params[:uploaded_file_name] || File.basename(file.path)
      file_name += ".pdf" unless File.extname(file_name) == ".pdf"
      post_request "batch/#{batch_id}/batch-file/", {
        uploaded_file: file,
        file_name: file_name,
        uploader: params[:uploader] || "Rafi",
        assemble_immediately: params[:assemble_immediately] || false
      }
    end

    # Jobs
    def get_jobs
      get_request "job/"
    end

    def get_job(job_id, deep=false)
      suffix = if deep then "/deep/" else "" end
      get_request "job/#{job_id}#{suffix}"
    end

    def get_job_price(job_id)
      get_request "job/#{job_id}/price"
    end

    def get_job_readiness(job_id)
      get_request "job/#{job_id}/readiness"
    end

    def create_job(name, template_id)
      post_request "job/", {
        name: name,
        document_id: template_id,
        finished_callback: JOB_CALLBACK
      }
    end

    def delete_job(job_id)
      delete_request "job/#{job_id}"
    end

    def get_job_csv(job_id)
      get_request "job/#{job_id}/csv/"
    end

    def get_instance_sets(job_id)
      get_request "job/#{job_id}/instance-set/"
    end

    def get_instance_set(is_id)
      get_request "instance-set/#{is_id}"
    end

    def get_instance_set_instances(is_id)
      get_request "instance-set/#{is_id}/instance/"
    end

    def get_instance(instance_id)
      get_request "instance/#{instance_id}"
    end

    def get_instance_aligned_image(instance_id)
      "instance/#{instance_id}/aligned-image"
    end

    # Shreds
    def get_shreds(is_id)
      get_request "instance-set/#{is_id}/shred/"
    end

    def get_shred(shred_id)
      get_request "shred/#{shred_id}"
    end

    def get_shred_image(shred_id)
      get_request "shred/#{shred_id}/image"
    end

    def get_shred_thumbnail(shred_id, size=100)
      get_request "shred/#{shred_id}/thumbnail/#{size}w"
    end


    # Templates
    def get_templates
      get_request "document/"
    end

    def get_template(template_id, deep=true)
      suffix = if deep then "deep/" else "" end
      get_request "document/#{template_id}/#{suffix}"
    end

    # An individual sheet of a template. Call template.sheets[0]["id"]
    def get_sheet_image(sheet_id)
      @client[url].get "sheet/#{sheet_id.to_s}/image"
    end

    def get_sheet_thumbnail(sheet_id, size=100)
      size = 100 unless [100, 300, 590].include? size
      @client[url].get "sheet/#{sheet_id}/thumbnail/#{size}w"
    end


    private

    # Generic get request
    def get_request(url)
      begin
        r = @client[url].get
      rescue => e
        r = e.response
      end
      json_to_hash r
    end

    # Generic post request
    def post_request(url, params)
      begin
        r = @client[url].post params
      rescue => e
        r = e.response
      end
      json_to_hash r
    end

    def delete_request(url)
      begin
        r = @client[url].delete || "{}"
      rescue => e
        r = e.response
      end
      json_to_hash r
    end

    # Parses JSON to hash. Will eventually do more. 
    # @param{string} json The JSON string.
    # @return{hash} The JSON object as a hash. 
    def json_to_hash(json)
      hash = JSON.parse(json)
      # symbolize_keys_deep! hash
    end

    # def symbolize_keys_deep!(h)
    #   h.keys.each do |k|
    #     ks    = k.to_sym
    #     h[ks] = h.delete k
    #     symbolize_keys_deep! h[ks] if h[ks].kind_of? Hash
    #   end
    # end
  end
end