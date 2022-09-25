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

unjsoned_parlamentar = URI.open("https://legis.senado.leg.br/dadosabertos/senador/lista/atual.json").read

@parlamentar = JSON.parse(unjsoned_parlamentar)["ListaParlamentarEmExercicio"]["Parlamentares"]["Parlamentar"].first["IdentificacaoParlamentar"]

@parlamentares = JSON.parse(unjsoned_parlamentar)["ListaParlamentarEmExercicio"]["Parlamentares"]["Parlamentar"]

@parlamentares.each do |parlamentar|
  @senator = Senator.new

  @senator.name = parlamentar["IdentificacaoParlamentar"]["NomeParlamentar"]
  @senator.party = parlamentar["IdentificacaoParlamentar"]["SiglaPartidoParlamentar"]
  @senator.senate_key = parlamentar["IdentificacaoParlamentar"]["CodigoParlamentar"]
  @senator.save!

  unjsoned_votes = URI.open("https://legis.senado.leg.br/dadosabertos/senador/#{@senator.senate_key}/votacoes.json?sigla=PEC").read
  next if JSON.parse(unjsoned_votes)["VotacaoParlamentar"]["Parlamentar"].nil?

  @votes = JSON.parse(unjsoned_votes)["VotacaoParlamentar"]["Parlamentar"]["Votacoes"]["Votacao"].first

  @bill = Bill.new
  @bill.name = @votes["Materia"]["DescricaoIdentificacao"]
  @bill.description = @votes["DescricaoVotacao"]
  @bill.save!

  @vote = Vote.new
  @vote.session_code = @votes["CodigoSessaoVotacao"]
  @vote.choice = @votes["SiglaDescricaoVoto"]
  @vote.senator = @senator
  @vote.bill = @bill
  @vote.save!
end

puts 'seeding finished'
