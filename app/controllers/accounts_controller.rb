class AccountsController < ApplicationController
  before_action :set_account_book
  before_action :set_account, only: %i[ show edit update destroy ]

  # GET /accounts
  def index
    @accounts = @account_book.accounts.all
  end

  # GET /accounts/1
  def show
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  def create
    @account = @account_book.accounts.new account_params

    if @account.save
      redirect_to :accounts
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounts/1
  def update
    if @account.update(account_params)
      redirect_to @account, notice: "Account was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /accounts/1
  def destroy
    @account.destroy
    redirect_to accounts_url, notice: "Account was successfully destroyed."
  end

  private

  def set_account_book
    @account_book = current_user.account_book_memberships.first.account_book
  end

  def set_account
    @account = @account_book.accounts.find params[:id]
  end

  def account_params
    params.require(:account).permit(:name)
  end
end
