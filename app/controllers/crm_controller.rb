# frozen_string_literal: true

class CrmController < ApplicationController

  # GET /crm_cancel
  def cancel
    @current_user.ghl_remove_integration!
    redirect_to(edit_user_path(@current_user),
      alert: 'CRM Integration has been canceled. Feel free to renew it at any time')
  end
end
