namespace :riders do
  desc 'reminder jobs'
    #task to send emails to users that are signed up for a ride tomorrow
    #usage with console output:
    #   bundle exec rake riders:reminders[console]
    #usage from with no console output:
    #   bundle exec rake riders:reminders
    task :reminders, [:console] => :environment do |t, args|
      puts "******************************" if args.console == "console"
      puts "** starting rider reminder ***" if args.console == "console"
      puts "******************************" if args.console == "console"

      #retreive all slots that for tomorrow whose status is signed up
      slots = Slot.all(:conditions => ['date = ?', Date.today + 1])

      #loop through all slots
      slots.each do |s|
        puts "checking slot starting at #{s.start_time}" if args.console == "console"

        #get all users for the slot
        users = s.users

        #loop through all user
        users.each do |u|
          #TODO: only send email to users who are not on the waiting list
          puts "sending an email to #{u.first_name} #{u.last_name}" if args.console == "console"
          UserMailer.reminder_email(u,s).deliver
        end
      end
    end
end