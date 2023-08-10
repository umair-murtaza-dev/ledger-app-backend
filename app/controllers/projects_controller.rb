require 'csv'

class ProjectsController < ApplicationController
  def export
    @projects = Project.all

    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=projects.csv"
        render "projects/export.csv.erb"
      end
      format.html do
        render :index
      end
    end
  end
end
