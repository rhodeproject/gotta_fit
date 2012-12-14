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
      @users = User.find_by_created_at(Date.today)
      if args.console == "console"
        write_console unless @users.nil?
      else
        send_email unless @users.nil?
      end
    end
end

def send_email
  UserMailer.nightly_user_count(@users) unless @users.nil
end

def write_console
  @users.each do |u|
    puts "----------------"
    puts "Name: #{u.name}"
    puts "email #{u.email}"
  end
end