# Load all classes
Rails.application.eager_load!

def order_id
  random_string = (0...30).map { rand(65..90).chr }.join + (0...30).map { rand(10).to_s }.join
  random_string.chars.sample(30).join
end

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
  lead_order.agent_phone = Faker::Base.numerify('+1##########')
  lead_order.agent_email = Faker::Internet.email
  lead_order.lead_class = lead_const.sample
  lead_order.max_per_day = [10, 100, 500, 1000, nil].sample
  lead_order.total_lead_order = 1100
  lead_order.days_per_week = dpw.sample
  lead_order.paused_until = [1.day.ago, 1.day.from_now, 30.days.from_now, nil].sample
  lead_order.states = [%w[ca id], %w[ny or], %w[wy]].sample
  lead_order.order_id = order_id
  lead_order.save!
end
