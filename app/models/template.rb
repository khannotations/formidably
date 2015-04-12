require 'captricity/api'

class Template < ActiveRecord::Base
  include Captricity

  validates_presence_of :name, :cid, :captricity_created_at, 
    :page_count
  validates_inclusion_of :active, :in => [true, false]
  validates_inclusion_of :deleted, :in => [true, false]

  has_many :jobs

  scope :visible, -> { includes(:jobs).where(active: true, deleted: false) }

  def image_url
    Captricity::API::BASE_URL + "sheet/#{self.front_sheet_id}/image"
  end

  def thumbnail_url(size=300)
    Captricity::API::BASE_URL + "sheet/#{self.front_sheet_id}/thumbnail/#{size}w"
  end

  def serializable_hash(options={})
    options = {
      # :include => :jobs,
      :except => [
        :created_at, :updated_at
      ],
      :methods => [:thumbnail_url, :image_url]
    }.update(options)
    super(options)
  end

  # Class methods

  def self.sync
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
          deleted: !t["user_visible"],
          front_sheet_id: t["sheets"][0]["id"]
        })
      end
      puts
    else
      puts "Couldn't retrieve templates"
    end
  end
end
