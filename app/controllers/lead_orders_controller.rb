# frozen_string_literal: true

class LeadOrdersController < ApplicationController
  before_action :set_lead_order, only: %i[show edit update destroy]

  # GET /lead_orders or /lead_orders.json
  def index
    # LeadOrderDatatable handles @lead_orders
  end

  # GET /lead_orders/1 or /lead_orders/1.json
  def show
  end

  # GET /lead_orders/new
  def new
    @lead_order = LeadOrder.new
  end

  # GET /lead_orders/1/edit
  def edit
  end

  # POST /lead_orders or /lead_orders.json
  def create
    @lead_order = LeadOrder.new(lead_order_params.merge(user: @current_user))

    respond_to do |format|
      if @lead_order.save
        format.html { redirect_to lead_orders_path, notice: 'Lead order was successfully created.' }
        format.json { render :show, status: :created, location: @lead_order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lead_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lead_orders/1 or /lead_orders/1.json
  def update
    respond_to do |format|
      if @lead_order.update(lead_order_params)
        format.html { redirect_to lead_orders_path, notice: 'Lead order was successfully updated.' }
        format.json { render :show, status: :ok, location: @lead_order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lead_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lead_orders/1 or /lead_orders/1.json
  def destroy
    @lead_order.destroy!

    respond_to do |format|
      format.html do
        redirect_to lead_orders_path, status: :see_other, notice: 'Lead order was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  # PATCH /lead_orders/1/cancel
  def cancel
    @lead_order = LeadOrder.find(params[:id])
    if @lead_order.update(canceled_at: Time.now.utc) # Or your cancellation logic
      redirect_to lead_orders_path, notice: 'Order canceled successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # To load lead order datatable
  def datatable
    respond_to do |format|
      format.json { render json: LeadOrderDatatable.new(params, user: @current_user) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_lead_order
    @lead_order = LeadOrder.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def lead_order_params
    parms = params.expect(
      lead_order: [
        :user_id,
        :expire_on,
        :lead_class,
        :active,
        :max_per_day,
        :paused_until,
        :email,
        :phone,
        { days_per_week: [] },
        { states: [] }
      ]
    )
    parms[:days_per_week] = normalize_array_param(parms, :days_per_week)
    parms[:states] = normalize_array_param(parms, :states)
    parms
  end
end
