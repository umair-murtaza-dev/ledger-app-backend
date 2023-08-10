require 'csv'

class StoreLocationsController < ApplicationController
  def export
    @store_locations = StoreLocation.all

    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=store_locations.csv"
        render "store_locations/export.csv.erb"
      end
      format.html do
        render :index
      end
    end
  end
end
