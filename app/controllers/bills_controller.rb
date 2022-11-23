class BillsController < ApplicationController
  def show
    @bill = Bill.find(params[:materia])
  end
end
