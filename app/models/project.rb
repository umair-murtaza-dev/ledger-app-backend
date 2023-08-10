class Project < ApplicationRecord
  acts_as_paranoid

  belongs_to :company

  def self.apply_filter(query)
    projects = where("lower(projects.title) LIKE :term", term: "%#{query.downcase}%")
    projects
  end
end
