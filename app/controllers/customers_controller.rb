require 'csv'

class CustomersController < ApplicationController
  def export
    @customers = Customer.all

    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=customers.csv"
        render "customers/export.csv.erb"
      end
      format.html do
        render :index
      end
    end
  end
end
