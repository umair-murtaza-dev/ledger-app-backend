require 'csv'

class InventoryItemsController < ApplicationController
  def export
    @inventory_items = InventoryItem.all

    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=inventory_items.csv"
        render "inventory_items/export.csv.erb"
      end
      format.html do
        render :index
      end
    end
  end
end
