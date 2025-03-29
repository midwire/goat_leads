# frozen_string_literal: true

# Load all classes
Rails.application.eager_load!

puts('>>> Seeding Users')
lead_const = ObjectSpace.each_object(Class).select { |klass| klass < Lead }
user = User.find_or_create_by(
  email_address: 'leads@example.com'
)
user.update!(
  password: 'asdfasdf',
  password_confirmation: 'asdfasdf',
  email_verified_at: Time.now.utc,
  licensed_states: State.all,
  video_types: %w[dom other]
)
user = User.find_or_create_by(
  email_address: 'admin@example.com'
)
user.update!(
  password: 'asdfasdf',
  password_confirmation: 'asdfasdf',
  email_verified_at: Time.now.utc,
  role: :admin
)

# Jeromy
user = User.find_or_create_by(
  email_address: 'leadsupport@goatleads.com'
)
user.update!(
  password: 'asdfasdf',
  password_confirmation: 'asdfasdf',
  email_verified_at: Time.now.utc,
  role: :admin
)

# Mike
user = User.find_or_create_by(
  email_address: 'mpfeil@fflall.com'
)
user.update!(
  password: 'asdfasdf',
  password_confirmation: 'asdfasdf',
  email_verified_at: Time.now.utc,
  role: :admin
)
