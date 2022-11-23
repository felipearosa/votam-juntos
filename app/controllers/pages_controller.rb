require 'open-uri'
require 'json'

class PagesController < ApplicationController
  def home
    @senadores = Senator.all
    @bills = Bill.all
  end
end
