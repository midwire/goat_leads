# Load all classes
Rails.application.eager_load!

Lead.destroy_all
puts('>>> Seeding Leads')
user = User.find_by(email_address: 'leadorders@example.com')
lead_orders = user.lead_orders
lead_const = ObjectSpace.each_object(Class).select { |klass| klass < Lead }
50.times do |i|
  lead = lead_const.sample.new
  lead.first_name = Faker::Name.first_name
  lead.last_name = Faker::Name.last_name
  lead.phone = Faker::Base.numerify('+1##########')
  lead.email = Faker::Internet.email
  lead.state = Faker::Address.state
  lead.save!

  lead_order = LeadOrder.eligible_for_lead(lead).first

  lead.lead_order = lead_order
  lead.dob = Faker::Date.between(from: '1930-01-01', to: 21.years.ago)
  lead.marital_status = Faker::Demographic.marital_status
  lead.military_status = Faker::Military.army_rank
  lead.needed_coverage = ['250,000+', '40,000 - 50,000', '20,000 - 30,000'].sample
  lead.contact_time_of_day = %w[Afternoon Evening Morning].sample
  lead.ad = Faker::Lorem.word
  lead.adset_id = "#{lead.ad} #{Faker::Lorem.words(number: 3).join(' ')}"
  lead.platform = %w[yt fb ig].sample
  lead.campaign_id = Faker::Lorem.words(number: 5).join(' ')
  lead.ringy_code = Faker::Number.number(digits: 15)
  lead.lead_program = %w[IUL FEX].sample
  lead.ip_address = Faker::Internet.public_ip_v4_address
  lead.location = Faker::Address.city
  lead.trusted_form_url = Faker::Internet.url(host: 'example.com')
  lead.verified_lead = [true, false].sample
  lead.unique = [true, false].sample
  lead.external_lead_id = Faker::Number.number(digits: 15)
  lead.video_type = %w[other dom].sample
  lead.lead_date = Faker::Date.between(from: 1.day.ago, to: 1.year.ago)
  lead.age = Faker::Number.between(from: 21, to: 91)
  lead.lead_quality = %w[Premium Standard].sample
  lead.save!
end
