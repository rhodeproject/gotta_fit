namespace :slots do
  desc "remove all slots"
  task :remove => :environment do
    puts "removing all slots"
    slots = Slot.all
    slots.each do |s|
      puts "removing slot id:#{s.id}"
      s.destroy
    end
  end
end
