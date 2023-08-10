require 'csv'

class HeadOfAccountsController < ApplicationController
  def export
    @head_of_accounts = HeadOfAccount.all

    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=head_of_accounts.csv"
        render "head_of_accounts/export.csv.erb"
      end
      format.html do
        render :index
      end
    end
  end
end
