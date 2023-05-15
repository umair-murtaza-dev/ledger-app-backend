require 'csv'

class InvoicesController < ApplicationController
  def export
    @invoices = Invoice.all

    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=invoices.csv"
        render "invoices/export.csv.erb"
      end
      format.html do
        render :index
      end
    end
  end
end
