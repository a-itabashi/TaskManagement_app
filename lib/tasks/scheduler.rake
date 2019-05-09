desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :environment do
  puts "Updating feed..."
  puts "done."
end

task :deadline_mailer => :environment do
  @announce_deadline = Task.where("deadline <= ?", (Time.zone.today+7.day)).where("deadline > ?", (Time.zone.today)).where("status != ?", "完了")
    
  @send_mails = []

  i = 0
  while i <  @announce_deadline.length do
    list = @announce_deadline[i]
    DeadlineMailer.deadline(list).deliver
    @send_mails << list
    i += 1
  end

  puts "############################"
  puts "合計#{i}人にメールを送りました"
  @send_mails.each_with_index do |list,index|
    puts "----------------------------"
    puts "メール送信者　#{index+1}人目"    
    puts "名前：#{list.user.name}"
    puts "タスクのタイトル:#{list.title}"
    puts "終了期日:#{list.deadline.strftime("%Y年%m月%d日")}"
    puts "----------------------------"
  end  
end