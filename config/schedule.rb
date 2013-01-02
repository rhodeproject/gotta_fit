# Learn more: http://github.com/javan/whenever
every 1.day, :at => '5:30 pm' do
  rake "riders:reminders"
end

every 1.day, :at => '11:59 pm' do
  rake "riders:reminders"
end

every 1.day, :at => '11:58 pm' do
  rake "nightly:new_users"
end
