require 'captricity/api'
namespace :captricity do
  desc "Downloads active templates from Captricity API and replaces current templates"
  task :sync_templates => :environment do
    include Captricity

    c = Captricity::API.new
    templates = c.get_templates
    
    if templates.is_a? Array
      Template.destroy_all
      print "creating templates"
      templates.each do |t|
        print "."
        Template.create!({
          name: t["name"],
          cid: t["id"],
          captricity_created_at: DateTime.iso8601(t["created"]),
          page_count: t["page_count"],
          default_blank_value: t["default_blank_value"],
          active: t["active"],
          deleted: t["user_visible"],
          front_sheet_id: t["sheets"][0]["id"]
        })
      end
      puts
    else
      puts "Couldn't retrieve templates"
    end
  end
end