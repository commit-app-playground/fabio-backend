class ApplicationController < ActionController::Base
  def current_user
    # Account MVP version, no authentication
    session[:pid] = params[:pid] if params[:pid].present?
    @person = Person.find session[:pid] if session[:pid]
    return @person if @person

    # if for some reason the @person is not initialized
    @oerson = Person.last.tap { |p| session[:pid] = p.id }
  end
end
