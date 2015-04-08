require 'rest-client'
require 'json'
# A Ruby class for communicating with the Captricity API.
# API documentation is at https://shreddr.captricity.com/developer/api-reference
module Captricity
  class API
    include RestClient # May use gem Faraday in production.
    @@BASE_URL = "https://shreddr.captricity.com/api/v1/"

    # Default to Formidably API key; will be removed in production.
    def initialize(api_key="cb870e6253ce41a8b96b706a2bd0278e")
      @api_key = api_key
    end

    # Get all the user's batches.
    # @return{hash} Response hash.
    def get_batches
      r = RestClient.get @@BASE_URL + "batch/",
        {"Captricity-API-Token" => @api_key}
      json_to_hash r
    end

    # Get the specified batch.
    # @param{number|string} id The batch ID.
    # @return{hash} Response hash.
    def get_batch(id)
      r = RestClient.get @@BASE_URL + "batch/" + id.to_s,
        {"Captricity-API-Token" => @api_key}
      json_to_hash r
    end

    # Create a batch with sensible defaults.
    # @param{hash} params The params hash.
    # @return{hash} Response hash.
    def create_batch(params={})
      r = RestClient.post @@BASE_URL + "batch/", {
        name: params[:name] || "CreatedFromApi",
        sorting_enabled: params[:sorting_enabled] || true,
        is_sorting_only: params[:is_sorting_only] || true,
        documents: [],
        schemas: []
      }, {"Captricity-API-Token" => @api_key}
      json_to_hash r
    end

    # Get all the files associated with a batch.
    # @param{number|string} batch_id The batch ID.
    # @return{hash} Response hash.
    def get_batch_files(batch_id)
      r = RestClient.get @@BASE_URL + "batch/#{batch_id.to_s}/batch-file/",
        {"Captricity-API-Token" => @api_key}
      json_to_hash r
    end

    # Upload a file to a given batch.
    # @param{number|string} batch_id The batch ID.
    # @param{File|string} file_handle Either a file object, or path to the file.
    # @return{hash} Response hash.
    def upload_file(batch_id, file_handle="./test.pdf", params={})
      if file_handle.is_a? String
        file = File.new(file_handle)
      else
        file = file_handle
      end
      r = RestClient.post @@BASE_URL + "batch/" + batch_id.to_s + "/batch-file/", {
        uploaded_file: file,
        file_name: params[:uploaded_file_name] || "test.pdf",
        uploader: params[:uploader] || "Rafi",
        assemble_immediately: params[:assemble_immediately] || false
      }, {"Captricity-API-Token" => @api_key}
      json_to_hash r
    end

    private

    # Parses JSON to hash. Will eventually do more. 
    # @param{string} json The JSON string.
    # @return{hash} The JSON object as a hash. 
    def json_to_hash(json)
      hash = JSON.parse(json)
    end
  end
end