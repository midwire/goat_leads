# frozen_string_literal: true

class LeadsController < ApplicationController
  before_action :set_lead, only: %i[show destroy edit]

  # GET /leads
  def index
    # LeadDatatable handles @leads
  end

  # GET /leads/:id
  def show
  end

  # GET /leads/:id/edit
  def edit
  end

  # DELETE /leads/1
  def destroy
    # NOTE: Don't allow lead deletion for now
    redirect_to leads_path, status: :see_other, alert: 'Leads cannot be deleted.'
    # @lead.destroy!
    #
    # respond_to do |format|
    #   format.html do
    #     redirect_to leads_path, status: :see_other, notice: 'Lead was successfully destroyed.'
    #   end
    #   format.json { head :no_content }
    # end
  end

  # POST /leads/datatable
  def datatable
    respond_to do |format|
      format.json do
        render json: LeadDatatable.new(
          params,
          user: @current_user,
          view_context: view_context
        )
      end
    end
  end

  private

  def set_lead
    @lead = Lead.find(params.expect(:id))&.decorate
  end
end
