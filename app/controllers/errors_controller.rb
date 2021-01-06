class ErrorsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def file_not_found
  end

  def unprocessable
  end

  def internal_server_error
  end
end
