# frozen_string_literal: true

# Users can edit their own profile and user info
class UsersController < ApplicationController
  def edit
    @user = Current.user
  end
end
