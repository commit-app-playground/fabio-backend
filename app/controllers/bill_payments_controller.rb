class BillPaymentsController < ApplicationController
  before_action :set_account_book
  before_action :set_bill
  before_action :set_bill_payment

  def new
    default_date = Date.current.change day: @bill.day
    @bill_payment = BillPayment.new date: default_date
  end

  def create
    @bill_payment = @bill.bill_payments.new payment_params
    if @bill_payment.save
      redirect_to [@bill, :bill_payment]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @bill_payment.update payment_params
      redirect_to [@bill, :bill_payment]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_bill
    @bill = @account_book.bills.find params[:bill_id]
  end

  def set_bill_payment
    # This is a workaround
    # Another controller should take in place for
    # - Current Payment routes
    # - Resoourseful payment edition routes
    if params[:id].to_i > 0
      @bill_payment = @bill.bill_payments.find params[:id]
    else
      @month = Date.current.month

      # there are edge cases (payments on subsequent months)
      # but for MVP purposes this is fine
      @bill_payment = @bill.bill_payments
        .find_by "DATE_PART('month', date) = ?", @month
    end
  end

  def payment_params
    amount = Money.from_amount params[:amount]&.to_d rescue nil
    params.require(:bill_payment).permit(:date).merge(amount: amount)
  end
end
