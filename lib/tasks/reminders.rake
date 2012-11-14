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

      #retreive all slots for tomorrow whose status is signed up
      slots = Slot.all(:conditions => ['date = ?', Date.today + 1])
      count = 0
      #loop through all slots
      slots.each do |s|
        puts "checking slot starting at #{s.start_time}" if args.console == "console"

        #get all users for the slot
        users = s.users

        #loop through all user
        users.each do |u|
          if u.get_slot_state(s.id) != "Waiting" && !u.reminder_sent?(s.id)
            count += 1
            puts "sending an email to #{u.first_name} #{u.last_name}" if args.console == "console"
            if UserMailer.reminder_email(u,s).deliver
               u.update_reminder_sent(s.id)
            end
          end
        end
      end
      UserMailer.admin_task("riders:reminders",count).deliver
    end
end