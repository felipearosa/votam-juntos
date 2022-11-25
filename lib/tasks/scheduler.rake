require 'date'

def create_bill_votes(vote, bill_save, vote_save, senator_save)
  if Bill.where(code: vote["Materia"]["Codigo"].to_s).empty?
    bill_save = Bill.new
    bill_save.name = vote["Materia"]["DescricaoIdentificacao"]
    bill_save.description = vote["DescricaoVotacao"]
    bill_save.kind = vote["Materia"]["Sigla"]
    bill_save.code = vote["Materia"]["Codigo"]
    bill_save.save!
  else
    bill_save = Bill.where(code: vote["Materia"]["Codigo"].to_s).first
  end

  vote_save = Vote.new
  vote_save.session_code = vote["CodigoSessaoVotacao"]
  vote_save.choice = vote["SiglaDescricaoVoto"]
  vote_save.senator = senator_save
  vote_save.bill = bill_save
  vote_save.save!
end

desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :environment do
  if Date.today.wday.zero?
    puts 'deleting'
    time = Time.now
    Vote.destroy_all
    Senator.destroy_all
    Bill.destroy_all
    puts 'seeding'
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
        next if votes["Materia"]["Sigla"] == "MSF" || votes["Materia"]["Sigla"] == "OFS" || votes["Materia"]["Sigla"] == "MSF"

        create_bill_votes(votes, @bill, @vote, @senator)
      else
        votes.each do |vote|
          next if vote["Materia"]["Sigla"] == "MSF" || vote["Materia"]["Sigla"] == "OFS" || vote["Materia"]["Sigla"] == "MSF"

          create_bill_votes(vote, @bill, @vote, @senator)
        end
      end

      puts "Senator #{i} - #{@senator.name} done"
      i += 1
    end

    finish_time = (Time.now - time).floor
    puts 'seeding finished'
    puts "finished in #{finish_time/60} minute(s) and #{finish_time%60} second(s)"

  end
end
