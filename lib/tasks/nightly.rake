#All jobs that run nightly
#They can be called bundle exec rake nightly:[task_name]
#
#new_user - will iterate through all users and count all the users added
#   on the current date.  It will take an optional argument [:console]
#   when the argument is passed to the task, the results will output to
#   to the console and not send an email

namespace :nightly do
  desc 'nightly jobs'
    task :new_users, [:console] => :environment do |t, args|
      @users = User.signed_up_today
      if args.console == "console"
        puts "checking users..."
        write_console unless @users.nil?
        puts "done"
      else
        send_email unless @users.nil?
      end
    end
end

def send_email
  UserMailer.nightly_user_count(@users).deliver unless @users.nil?
end

def write_console
  @users.each do |u|
    puts "----------------"
    puts "Name: #{u.name}"
    puts "email: #{u.email}"
    puts "joined: #{u.created_at}"
  end
end