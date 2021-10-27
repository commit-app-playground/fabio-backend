class ApplicationController < ActionController::Base
  private

  def current_user
    # Account MVP version, no authentication
    session[:pid] = params[:pid] if params[:pid].present?
    @person = Person.find session[:pid] if session[:pid]
    return @person if @person

    # if for some reason the @person is not initialized
    @oerson = Person.last.tap { |p| session[:pid] = p.id }
  end

  def set_account_book
    @account_book = current_user.account_book_memberships.first.account_book
  end
end
