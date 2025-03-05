# frozen_string_literal: true

class LeadsController < ApplicationController
  def index
    # LeadDatatable handles @leads
  end

  def datatable
    respond_to do |format|
      format.json { render json: LeadDatatable.new(params, user: @current_user) }
    end
  end
end
