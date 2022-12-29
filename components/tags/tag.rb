class Tags::Tag < ApplicationRecord

  # has_many :url_mapping_tags, class_name: "UrlMappings::UrlMappingTag",  dependent: :destroy
  # has_many :url_mappings, through: :url_mapping_tags, class_name: "UrlMappings::UrlMapping"

  validates :title, uniqueness: true
  validates :title, presence: true


  scope :by_title, -> (title) { where(title: title) }

end
