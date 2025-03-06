# frozen_string_literal: true

# Users can edit their own profile and user info
class UsersController < ApplicationController
  before_action :set_user

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to leads_path, notice: 'Profile saved.'
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  private

  def user_params
    parms = params.expect(user: [:first_name, :last_name, :phone, { licensed_states: [] }])
    parms[:licensed_states] = normalize_array_param(parms, :licensed_states)
    parms
  end

  def set_user
    @user = User.find(params.expect(:id))
  end

  def normalize_array_param(parms, attribute)
    # Normalize licensed_states array
    p = parms[attribute].map { |e| e.split(',') }.flatten
    p.map(&:strip)
  end
end
