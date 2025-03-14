# frozen_string_literal: true

class Admin::UsersController < AdminController
  before_action :set_user, except: %i[index datatable]

  def index
  end

  # GET /admin/users/:id/edit
  def edit
  end

  # To load lead order datatable
  # POST /lead_orders/datatable
  def datatable
    respond_to do |format|
      format.json { render json: UserDatatable.new(params, user: @user) }
    end
  end

  private

  def set_user
    @user = User.find(params.expect(:id))
  end
end
