require 'csv'

class AccountsController < ApplicationController
  def export
    @accounts = Account.all

    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=accounts.csv"
        render "accounts/export.csv.erb"
      end
      format.html do
        render :index
      end
    end
  end
end
