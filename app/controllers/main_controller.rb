class MainController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def dashboard
    @user = current_user
    org = @user.organization
    @jobs = org.jobs
    @batches = org.batches
    @templates = Template.visible
  end
end
