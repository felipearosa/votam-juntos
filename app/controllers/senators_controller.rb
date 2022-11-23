class SenatorsController < ApplicationController
  def show
    @senadores = Senator.all
  end

end
