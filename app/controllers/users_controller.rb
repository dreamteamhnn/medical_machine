class UsersController < ApplicationController
  def index
    @company = Company.first
  end
end
