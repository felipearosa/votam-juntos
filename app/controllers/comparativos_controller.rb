class ComparativosController < ApplicationController
  def show
    @senador_primary_id = params[:senador1]
    @senador_secondary_id = params[:senador2]

    unjsoned_votes_primary = URI.open("https://legis.senado.leg.br/dadosabertos/senador/#{@senador_primary_id}/votacoes.json").read
    @votes_primary = JSON.parse(unjsoned_votes_primary)
    @siglas = @votes_primary["VotacaoParlamentar"]["Parlamentar"]["Votacoes"]["Votacao"].map do |votacao|
      votacao["Materia"]["Sigla"]
    end
    @final_siglas = @siglas.uniq { |sigla| sigla }
    raise
  end

end
