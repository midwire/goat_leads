# frozen_string_literal: true

class LeadsController < ApplicationController
  def index
    @leads = Lead.all
  end

  def datatable
    respond_to do |format|
      format.json { render json: LeadDatatable.new(params, user: @user) }
    end
  end
end
