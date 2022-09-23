class ComparativosController < ApplicationController
  def show
    @senador_primary_id = params[:senador1]
    @senador_secondary_id = params[:senador2]

    unjsoned_votes_primary = URI.open("https://legis.senado.leg.br/dadosabertos/senador/#{@senador_primary_id}/votacoes.json?sigla=DEN").read
    @parlamentar_primary = JSON.parse(unjsoned_votes_primary)["VotacaoParlamentar"]["Parlamentar"]

    unjsoned_votes_secondary = URI.open("https://legis.senado.leg.br/dadosabertos/senador/#{@senador_secondary_id}/votacoes.json?sigla=DEN").read
    @parlamentar_secondary = JSON.parse(unjsoned_votes_secondary)["VotacaoParlamentar"]["Parlamentar"]

  end

end
