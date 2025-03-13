# Load all classes
Rails.application.eager_load!

LeadOrder.destroy_all
puts('>>> Seeding Lead Orders')
user = User.find_or_create_by(
  email_address: 'leadorders@example.com'
)
user.update(
  password: 'asdfasdf',
  password_confirmation: 'asdfasdf',
  email_verified_at: Time.now.utc
)
lead_const = ObjectSpace.each_object(Class).select { |klass| klass < Lead }
dpw = [%w[mon tue wed thu fri], %w[mon tue wed thu fri sat sun]]
10.times do |i|
  lead_order = LeadOrder.new
  lead_order.user = user
  lead_order.expire_on = [30.days.from_now, nil].sample
  lead_order.active = [true, false].sample
  lead_order.phone = Faker::Base.numerify('+1##########')
  lead_order.email = Faker::Internet.email
  lead_order.lead_class = lead_const.sample
  lead_order.max_per_day = [10, 100, 500, 1000, nil].sample
  lead_order.days_per_week = dpw.sample
  lead_order.paused_until = [1.day.ago, 1.day.from_now, 30.days.from_now, nil].sample
  lead_order.states = [%w[ca id], %w[ny or], %w[wy], []].sample
  lead_order.save
end
