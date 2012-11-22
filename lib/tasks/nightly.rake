namespace :nightly do
  describe "nightly jobs"
    task :new_users, [:email] => :environment do |t, args|
      @users = User.find_by_created_at(Date.today)
      if args.email == "email"
        send_email unless @users.nil?
      else
        write_console unless @users.nil?
        puts "All Done!"
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