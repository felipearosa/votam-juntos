require 'date'

desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :environment do
  if Date.today.wday.zero?
    runner "Event.clear_expired"
    runner "Activity.clear_expired"
  end

  puts "Updating feed..."
  puts "done."
end
