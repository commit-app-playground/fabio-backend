require "test_helper"

describe BillsController do
  let(:bill) { bills(:one) }

  it "should get index" do
    get bills_url
    must_respond_with :success
  end

  it "should get new" do
    get new_bill_url
    must_respond_with :success
  end

  it "should create bill" do
    assert_difference("Bill.count") do
      post bills_url, params: { bill: {  } }
    end

    must_redirect_to bill_url(Bill.last)
  end

  it "should show bill" do
    get bill_url(@bill)
    must_respond_with :success
  end

  it "should get edit" do
    get edit_bill_url(@bill)
    must_respond_with :success
  end

  it "should update bill" do
    patch bill_url(@bill), params: { bill: {  } }
    must_redirect_to bill_url(bill)
  end

  it "should destroy bill" do
    assert_difference("Bill.count", -1) do
      delete bill_url(@bill)
    end

    must_redirect_to bills_url
  end
end
