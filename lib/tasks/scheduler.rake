desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :environment do
  puts "Updating feed..."
  NewsFeed.update
  puts "done."
end

task :send_mails => :environment do
  @announce_deadline = Task.where("deadline <= ?", (Time.zone.today+7.day)).where("deadline > ?", (Time.zone.today)).where("status != ?", "完了")
    
    i = 0
    while i <  @announce_deadline.length do
      list = @announce_deadline[i]
      DeadlineMailer.deadline(list).deliver
      i += 1
    end
end