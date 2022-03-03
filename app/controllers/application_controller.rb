class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def api_key_valid?
    if request.headers["X-Api-Key"]
      api_key = request.headers["X-Api-Key"]
      tenant = Tenant.find_by(api_key: api_key)
      if tenant
        tenant.update_column(:number_of_requests, tenant.number_of_requests + 1)
        @tenant = tenant
      else
        render json: {status: 'ERROR', message: 'Invalid API key'}, status: :unauthorized
      end
    else
      render json: {status: 'ERROR', message: 'No API key'}, status: :unauthorized
    end
  end
end
