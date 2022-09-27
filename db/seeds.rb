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

# def create_bill_votes(vote, bill_save, vote_save, senator_save)
#   bill_save = Bill.new
#   bill_save.name = vote["Materia"]["DescricaoIdentificacao"]
#   bill_save.description = vote["DescricaoVotacao"]
#   bill_save.type = vote["Materia"]["Sigla"]
#   bill_save.code = vote["Materia"]["Codigo"]
#   bill_save.save!

#   vote_save = Vote.new
#   vote_save.session_code = vote["CodigoSessaoVotacao"]
#   vote_save.choice = vote["SiglaDescricaoVoto"]
#   vote_save.senator = @senator
#   vote_save.bill = bill_save
#   vote_save.save!
# end

unjsoned_parlamentares = URI.open("https://legis.senado.leg.br/dadosabertos/senador/lista/atual.json").read

# test
@parlamentares = JSON.parse(unjsoned_parlamentares)["ListaParlamentarEmExercicio"]["Parlamentares"]["Parlamentar"].first(5)

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

  votes = JSON.parse(unjsoned_votes)["VotacaoParlamentar"]["Parlamentar"]["Votacoes"]["Votacao"].first(5)


  if votes.instance_of? Hash
    # next if votes["Materia"]["Sigla"] == "MSF" || votes["Materia"]["Sigla"] == "OFS" || votes["Materia"]["Sigla"] == "MSF"

    @bill = Bill.new
    @bill.name = votes["Materia"]["DescricaoIdentificacao"]
    @bill.description = votes["DescricaoVotacao"]
    @bill.type = votes["Materia"]["Sigla"]
    @bill.code = votes["Materia"]["Codigo"]
    @bill.save!

    @vote = Vote.new
    @vote.session_code = votes["CodigoSessaoVotacao"]
    @vote.choice = votes["SiglaDescricaoVoto"]
    @vote.senator = @senator
    @vote.bill = @bill
    @vote.save!


  else
    votes.each do |vote|
      # next if vote["Materia"]["Sigla"] == "MSF" || vote["Materia"]["Sigla"] == "OFS" || vote["Materia"]["Sigla"] == "MSF"

      @bill = Bill.new
      @bill.name = vote["Materia"]["DescricaoIdentificacao"]
      @bill.description = vote["DescricaoVotacao"]
      # @bill.type = vote["Materia"]["Sigla"]
      @bill.code = vote["Materia"]["Codigo"]
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
