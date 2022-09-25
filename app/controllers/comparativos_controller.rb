class ComparativosController < ApplicationController
  def show
    @senador_primary = Senator.find_by_senate_key(params[:senador1])
    @senador_secondary = Senator.find_by_senate_key(params[:senador2])

    @senador_primary_votes = @senador_primary.votes

    # unjsoned_votes_primary = URI.open("https://legis.senado.leg.br/dadosabertos/senador/#{@senador_primary_id}/votacoes.json?sigla=DEN").read
    # @parlamentar_primary = JSON.parse(unjsoned_votes_primary)["VotacaoParlamentar"]["Parlamentar"]

    # unjsoned_votes_secondary = URI.open("https://legis.senado.leg.br/dadosabertos/senador/#{@senador_secondary_id}/votacoes.json?sigla=DEN").read
    # @parlamentar_secondary = JSON.parse(unjsoned_votes_secondary)["VotacaoParlamentar"]["Parlamentar"]

  end

end
