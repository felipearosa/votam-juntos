require 'open-uri'
require 'json'

class PagesController < ApplicationController
  def home
    unjsoned_list = URI.open('https://legis.senado.leg.br/dadosabertos/senador/lista/legislatura/55/57.json?participacao=t').read
    list = JSON.parse(unjsoned_list)
    @parlamentares = list["ListaParlamentarLegislatura"]["Parlamentares"]["Parlamentar"].map do |parlamentar|
      parlamentar_info = {}
      parlamentar_info[:name] = parlamentar["IdentificacaoParlamentar"]["NomeParlamentar"]
      parlamentar_info[:partido] = parlamentar["IdentificacaoParlamentar"]["SiglaPartidoParlamentar"]
      parlamentar_info[:id] = parlamentar["IdentificacaoParlamentar"]["CodigoParlamentar"]
      parlamentar_info
    end
  end
end
