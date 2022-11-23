class BillsController < ApplicationController
  def show
    @bills = Bill.all
  end
end
