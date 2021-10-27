class BillsController < ApplicationController
  before_action :set_account_book
  before_action :set_account
  before_action :set_bill, only: %i[ show edit update destroy ]

  # GET /bills
  def index
    @bills = Bill.all
  end

  # GET /bills/1
  def show
  end

  # GET /bills/new
  def new
    @bill = Bill.new
  end

  # GET /bills/1/edit
  def edit
  end

  # POST /bills
  def create
    @bill = @account.bills.new bill_params

    if @bill.save
      redirect_to @account
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bills/1
  def update
    if @bill.update bill_params
      redirect_to @account
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /bills/1
  def destroy
    @bill.destroy
    redirect_to @account
  end

  private

  def set_account
    @account = @account_book.accounts.find params[:account_id]
  end

  def set_bill
    @bill = @account.bills.find params[:id]
  end

  def bill_params
    params.require(:bill).permit :name, :day
  end
end
