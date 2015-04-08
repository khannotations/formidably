module Captricity
  class API
    include RestClient
    @@BASE_URL = "https://shreddr.captricity.com/api/v1/"

    def initialize(api_key="cb870e6253ce41a8b96b706a2bd0278e")
      @api_key = api_key
      # RestClient.add_before_execution_proc do |req, params|
      #   params[:headers]["Captricity-API-Token"] = @api_key
      #   p params
      # end
    end

    def get_batches
      r = RestClient.get @@BASE_URL + "batch/",
        {"Captricity-API-Token" => @api_key}
      json_to_hash r
    end

    def get_batch(id)
      r = RestClient.get @@BASE_URL + "batch/" + id.to_s,
        {"Captricity-API-Token" => @api_key}
      json_to_hash r
    end

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

    def get_batch_files(batch_id)
      r = RestClient.get @@BASE_URL + "batch/#{batch_id.to_s}/batch-file/",
        {"Captricity-API-Token" => @api_key}
      json_to_hash r
    end

    # file_handle should either be a file object, or a string URL to 
    # where the file can be found
    def upload_file(batch_id, file_handle="./test.pdf", params={})
      if file_handle.is_a? File
        file = file_handle
      else
        file = File.new(file_handle)
      end
      r = RestClient.post @@BASE_URL + "batch/" + batch_id.to_s + "/batch-file/", {
        uploaded_file: file,
        file_name: params[:uploaded_file_name] || File.basename(file.path),
        uploader: params[:uploader] || "Rafi",
        assemble_immediately: params[:assemble_immediately] || false
      }, {"Captricity-API-Token" => @api_key}
      json_to_hash r
    end

    private

    # def symbolize_keys_deep!(h)
    #   h.keys.each do |k|
    #     ks    = k.to_sym
    #     h[ks] = h.delete k
    #     symbolize_keys_deep! h[ks] if h[ks].kind_of? Hash
    #   end
    # end

    def json_to_hash(json)
      hash = JSON.parse(json)
      # symbolize_keys_deep! hash
    end
  end
end

class CaptricityController < ApplicationController
  include Captricity

  @@captricity = Captricity::API.new

  def batches 
    @batches = @@captricity.get_batches
  end

  def batch
    @batch = @@captricity.get_batch(params[:id])
    @files = @@captricity.get_batch_files(params[:id])
    @file_url_base = "https://shreddr.captricity.com/api/v1/batch-file/"
  end

  def upload
    uploaded_io = params[:file]
    file_path = Rails.root.join('public', 'uploads', "#{rand(100)}" +
      uploaded_io.original_filename)
    File.open(file_path, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    @@captricity.upload_file(params[:id], file_path,
      uploaded_file_name: params[:filename])
    redirect_to '/batch/' + params[:id]
  end

  private
end
