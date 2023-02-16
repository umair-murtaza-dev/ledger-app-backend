require 'csv'

class ExpensesController < ApplicationController
  def export
    @expenses = Expense.all

    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=expenses.csv"
        render "expenses/export.csv.erb"
      end
      format.html do
        render :index
      end
    end
  end
end
