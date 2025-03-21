# frozen_string_literal: true

require 'securerandom'

# This webhook is for incoming lead orders
class Hooks::LeadOrdersController < WebhookController
  include LeadClassMapping

  before_action :set_or_create_agent, only: %i[create]
  before_action :set_lead_class, only: %i[create]
  before_action :set_lead_order, only: %i[update]

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

  # PUT /hooks/lead_orders/:id
  def update
    if @lead_order.update(states: params.expect(:states))
      head :success
    else
      Rails.logger.error(
        "Failed to update Lead Order: - #{lead_order.errors.full_messages}"
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
      first_name: agent_first_name,
      last_name: agent_last_name,
      password: password,
      password_confirmation: password
    )
  end

  # Don't use lead_order_params here as it will cause infinite recursion
  def set_lead_class
    @lead_class = lead_class(params[:data][:lead_program], params[:data][:lead_type])
  end

  def set_lead_order
    @lead_order = LeadOrder.find_by(order_id: params[:id])
  end

  def random_password(length = 20)
    characters = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + %w[! @ # $ % ^ & * - +]
    Array.new(length) { characters.sample(random: SecureRandom) }.join
  end

  def agent_first_name
    lead_order_params[:agent_name].split(' ').first&.titleize
  end

  def agent_last_name
    lead_order_params[:agent_name].split(' ').last&.titleize
  end
end
