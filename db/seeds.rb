# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Vote.destroy_all
Senator.destroy_all
Bill.destroy_all
puts 'seeding'
time = Time.now
i = 1

unjsoned_parlamentares = URI.open("https://legis.senado.leg.br/dadosabertos/senador/lista/atual.json").read

@parlamentares = JSON.parse(unjsoned_parlamentares)["ListaParlamentarEmExercicio"]["Parlamentares"]["Parlamentar"]

@parlamentares.each do |parlamentar|
  puts "Senator #{i} starting"
  @senator = Senator.new

  @senator.name = parlamentar["IdentificacaoParlamentar"]["NomeParlamentar"]
  puts "Senator name ok"
  @senator.party = parlamentar["IdentificacaoParlamentar"]["SiglaPartidoParlamentar"]
  puts "Senator party ok"
  @senator.senate_key = parlamentar["IdentificacaoParlamentar"]["CodigoParlamentar"]
  puts "Senator senate key ok"
  @senator.save!

  unjsoned_votes = URI.open("https://legis.senado.leg.br/dadosabertos/senador/#{@senator.senate_key}/votacoes.json").read
  next if JSON.parse(unjsoned_votes)["VotacaoParlamentar"]["Parlamentar"].nil?

  votes = JSON.parse(unjsoned_votes)["VotacaoParlamentar"]["Parlamentar"]["Votacoes"]["Votacao"]

  if votes.instance_of? Hash
    @bill = Bill.new
    @bill.name = votes["Materia"]["DescricaoIdentificacao"]
    @bill.description = votes["DescricaoVotacao"]
    @bill.save!

    @vote = Vote.new
    @vote.session_code = votes["CodigoSessaoVotacao"]
    @vote.choice = votes["SiglaDescricaoVoto"]
    @vote.senator = @senator
    @vote.bill = @bill
    @vote.save!
  else
    votes.each do |vote|
      @bill = Bill.new
      @bill.name = vote["Materia"]["DescricaoIdentificacao"]
      @bill.description = vote["DescricaoVotacao"]
      @bill.save!

      @vote = Vote.new
      @vote.session_code = vote["CodigoSessaoVotacao"]
      @vote.choice = vote["SiglaDescricaoVoto"]
      @vote.senator = @senator
      @vote.bill = @bill
      @vote.save!
    end
  end

  puts "Senator #{i} - #{@senator.name} done"
  i += 1
end

finish_time = (Time.now - time).floor
puts 'seeding finished'
puts "finished in #{finish_time/60} minute(s) and #{finish_time%60} second(s)"




# @parlamentar = JSON.parse('{
#   "IdentificacaoParlamentar": {
#   "CodigoParlamentar": "4770",
#   "CodigoPublicoNaLegAtual": "851",
#   "NomeParlamentar": "Izalci Lucas",
#   "NomeCompletoParlamentar": "Izalci Lucas Ferreira",
#   "SexoParlamentar": "Masculino",
#   "FormaTratamento": "Senador ",
#   "UrlFotoParlamentar": "http://www.senado.leg.br/senadores/img/fotos-oficiais/senador4770.jpg",
#   "UrlPaginaParlamentar": "http://www25.senado.leg.br/web/senadores/senador/-/perfil/4770",
#   "EmailParlamentar": "sen.izalcilucas@senado.leg.br",
#   "Telefones": {
#   "Telefone": [
#   {
#   "NumeroTelefone": "33036049",
#   "OrdemPublicacao": "1",
#   "IndicadorFax": "Não"
#   },
#   {
#   "NumeroTelefone": "33036050",
#   "OrdemPublicacao": "2",
#   "IndicadorFax": "Não"
#   }
#   ]
#   },
#   "SiglaPartidoParlamentar": "PSDB",
#   "UfParlamentar": "DF",
#   "MembroMesa": "Não",
#   "MembroLideranca": "Sim"
#   },
#   "Mandato": {
#   "CodigoMandato": "552",
#   "UfParlamentar": "DF",
#   "PrimeiraLegislaturaDoMandato": {
#   "NumeroLegislatura": "56",
#   "DataInicio": "2019-02-01",
#   "DataFim": "2023-01-31"
#   },
#   "SegundaLegislaturaDoMandato": {
#   "NumeroLegislatura": "57",
#   "DataInicio": "2023-02-01",
#   "DataFim": "2027-01-31"
#   },
#   "DescricaoParticipacao": "Titular",
#   "Suplentes": {
#   "Suplente": [
#   {
#   "DescricaoParticipacao": "1º Suplente",
#   "CodigoParlamentar": "5968",
#   "NomeParlamentar": "Luis Felipe Belmonte"
#   },
#   {
#   "DescricaoParticipacao": "2º Suplente",
#   "CodigoParlamentar": "5969",
#   "NomeParlamentar": "Andre Filipe"
#   }
#   ]
#   },
#   "Exercicios": {
#   "Exercicio": [
#   {
#   "CodigoExercicio": "2909",
#   "DataInicio": "2019-02-01"
#   }
#   ]
#   }
#   }
#   }')


# @senator = Senator.new

# @senator.senate_key = @parlamentar["IdentificacaoParlamentar"]["CodigoParlamentar"]
# @senator.party = @parlamentar["IdentificacaoParlamentar"]["SiglaPartidoParlamentar"]
# @senator.name = @parlamentar["IdentificacaoParlamentar"]["NomeParlamentar"]
# @senator.save!

# unjsoned_votes = URI.open("https://legis.senado.leg.br/dadosabertos/senador/4770/votacoes.json").read

# JSON.parse(unjsoned_votes)["VotacaoParlamentar"]["Parlamentar"]["Votacoes"]["Votacao"].each do |vote|
#   @bill = Bill.new
#   @bill.name = vote["Materia"]["DescricaoIdentificacao"]
#   @bill.description = vote["DescricaoVotacao"]
#   @bill.save!

#   puts "bill #{i} saved"
#   @vote = Vote.new
#   @vote.session_code = vote["CodigoSessaoVotacao"]
#   @vote.choice = vote["SiglaDescricaoVoto"]
#   @vote.senator = @senator
#   @vote.bill = @bill
#   @vote.save!
#   puts "vote #{i} saved"
#   i += 1
# end

# puts 'done'
