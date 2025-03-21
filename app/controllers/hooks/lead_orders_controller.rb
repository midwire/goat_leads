# frozen_string_literal: true

require 'securerandom'

# This webhook is for incoming lead orders
class Hooks::LeadOrdersController < WebhookController
  include LeadClassMapping

  before_action :set_or_create_agent
  before_action :set_lead_class

  # POST /hooks/lead_orders
  def create
    lead_order = LeadOrder.new(lead_order_params.merge(user_id: @user.id))
    if lead_order.save
      head :created
    else
      Rails.logger.error(
        "Failed to create Lead Order: RowID: #{params[:row_number]} - #{lead_order.errors.full_messages}"
      )
      head :unprocessable_content
    end
  end

  private

  # rubocop:disable Metrics/MethodLength
  def lead_order_params
    parms = params.expect(
      data: %i[
        ordered_at
        detail
        agent_name
        amount
        discount
        paid
        frequency
        count
        lead_program
        lead_type
        agent_email
        agent_phone
        google_sheet_url
        states
        url_source
        quantity
        total_leads
        bump_order
        total_lead_order
        ringy_sid
        ringy_auth_token
        max_per_day
        order_id
        days_per_week
        name_on_sheet
        imo
        lead_class
      ]
    )
    parms[:states] = normalize_array_param(parms, :states)
    parms[:days_per_week] = normalize_array_param(parms, :days_per_week)
    parms[:lead_class] ||= @lead_class
    parms
  end
  # rubocop:enable Metrics/MethodLength

  def set_or_create_agent
    agent_email = lead_order_params[:agent_email].downcase
    @user = User.find_by(email_address: agent_email)
    return if @user.present?

    password = random_password
    @user = User.create(
      email_address: agent_email,
      phone: lead_order_params[:agent_phone],
      licensed_states: normalize_array_param(lead_order_params, :states),
      password: password,
      password_confirmation: password
    )
  end

  def set_lead_class
    @lead_class = lead_class(params[:data][:lead_program], params[:data][:lead_type])
  end

  def random_password(length = 20)
    characters = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + %w[! @ # $ % ^ & * - +]
    Array.new(length) { characters.sample(random: SecureRandom) }.join
  end
end
