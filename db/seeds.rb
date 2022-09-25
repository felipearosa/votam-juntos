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

i = 0

unjsoned_parlamentares = URI.open("https://legis.senado.leg.br/dadosabertos/senador/lista/atual.json").read

@parlamentares = JSON.parse(unjsoned_parlamentares)["ListaParlamentarEmExercicio"]["Parlamentares"]["Parlamentar"]

@parlamentares.each do |parlamentar|
  @senator = Senator.new

  @senator.name = parlamentar["IdentificacaoParlamentar"]["NomeParlamentar"]
  @senator.party = parlamentar["IdentificacaoParlamentar"]["SiglaPartidoParlamentar"]
  @senator.senate_key = parlamentar["IdentificacaoParlamentar"]["CodigoParlamentar"]
  @senator.save!

  unjsoned_votes = URI.open("https://legis.senado.leg.br/dadosabertos/senador/#{@senator.senate_key}/votacoes.json?sigla=PEC").read
  next if JSON.parse(unjsoned_votes)["VotacaoParlamentar"]["Parlamentar"].nil?

  JSON.parse(unjsoned_votes)["VotacaoParlamentar"]["Parlamentar"]["Votacoes"]["Votacao"].each do |vote|
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

  puts "Senator #{i} done"
  i += 1
end

puts 'seeding finished'
