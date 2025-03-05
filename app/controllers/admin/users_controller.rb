# frozen_string_literal: true

class Admin::UsersController < AdminController
  def datatable
    respond_to do |format|
      format.json { render json: UserDatatable.new(params, user: @user) }
    end
  end
end
