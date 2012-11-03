# Learn more: http://github.com/javan/whenever
every 1.day, :at => '5:30 pm' do
  rake "riders:reminders"
end
