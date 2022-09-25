require 'open-uri'
require 'json'

class PagesController < ApplicationController
  def home


    @senadores = Senator.all
  end
end
