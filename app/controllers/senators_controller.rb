class SenatorsController < ApplicationController
  def show
    @senador = Senator.find_by_senate_key(params[:senador])
  end

end
