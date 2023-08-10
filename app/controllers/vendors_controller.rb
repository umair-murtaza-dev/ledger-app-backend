require 'csv'

class VendorsController < ApplicationController
  def export
    @vendors = Vendor.all

    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=vendors.csv"
        render "vendors/export.csv.erb"
      end
      format.html do
        render :index
      end
    end
  end
end
