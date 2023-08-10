require 'csv'

class InventoryLocationsController < ApplicationController
  def export
    @inventory_locations = InventoryLocation.all

    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=inventory_locations.csv"
        render "inventory_locations/export.csv.erb"
      end
      format.html do
        render :index
      end
    end
  end
end
