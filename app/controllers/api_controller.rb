class ApiController < ApplicationController
  def token
    if user_signed_in?
      render json: {token: "cb870e6253ce41a8b96b706a2bd0278e"}
    else
      render json: {error: "Unauthorized"}, status: :forbidden
    end
  end
end
