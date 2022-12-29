class Histories::History < ApplicationRecord


  belongs_to :url_mapping, class_name: 'UrlMappings::UrlMapping'
end
