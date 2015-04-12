require 'captricity/api'
namespace :captricity do
  desc "Downloads active templates from Captricity API and replaces current templates"
  task :sync_templates => :environment do
    Template.sync
  end
end