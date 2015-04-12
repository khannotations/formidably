class Template < ActiveRecord::Base
  include Captricity

  validates_presence_of :name, :cid, :captricity_created_at, 
    :page_count
  validates_inclusion_of :active, :in => [true, false]
  validates_inclusion_of :deleted, :in => [true, false]

  has_many :jobs

  def image_url
    Captricity::API::BASE_URL + "sheet/#{self.front_sheet_id}/image"
  end

  def thumbnail_url(size=300)
    Captricity::API::BASE_URL + "sheet/#{self.front_sheet_id}/thumbnail/#{size}w"
  end
end
