class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: :render_500
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActionController::UnknownController, with: :render_404
    rescue_from ActionController::UnknownAction, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
  end

  private
  def render_404(exception)
    @not_found_path = exception.message
    respond_to do |format|
      format.html { render template: 'errors/error_404', layout: 'layouts/application', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end

  def render_500(exception)
    @error = exception
    respond_to do |format|
      format.html { render template: 'errors/error_500', layout: 'layouts/application', status: 500 }
      format.all { render nothing: true, status: 500}
    end
  end

  def set_locale
    I18n.locale = extract_locale_from_subdomain || I18n.default_locale
    puts "LOCAL #{I18n.locale}"
  end

  def extract_locale_from_subdomain
    parsed_locale = request.subdomains.first || 'en'
    I18n.available_locales.include?(parsed_locale.to_sym) ? parsed_locale : nil
  end
end