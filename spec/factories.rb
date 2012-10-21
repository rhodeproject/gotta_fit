Factory.define :user do |f|
  f.sequence(:email) { |n| "foo#{rand(1000)}@example.com" }
  f.first_name "foo"
  f.last_name "bar"
  f.password "secret"
  f.password_confirmation "secret"
end