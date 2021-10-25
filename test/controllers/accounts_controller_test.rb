require "test_helper"

describe AccountsController do
  let(:account) { accounts :home }

  it "should get index" do
    get '/accounts'
    assert_response :success
  end

  it "should get new" do
    get '/accounts/new'
    assert_response :success
  end

  it "should create account" do
    assert_difference("Account.count") do
      post '/accounts', params: { account: { name: account.name } }
    end

    assert_redirected_to "/accounts/#{Account.last.id}"
  end

  it "should show account" do
    get "/accounts/#{account.id}"
    assert_response :success
  end

  it "should get edit" do
    get "/accounts/#{account.id}/edit"
    assert_response :success
  end

  it "should update account" do
    patch "/accounts/#{account.id}", params: { account: { name: account.name } }
    assert_redirected_to "/accounts/#{account.id}"
  end

  it "should destroy account" do
    assert_difference("Account.count", -1) do
      delete "/accounts/#{accounts(:beach_house).id}"
    end

    assert_redirected_to '/accounts'
  end
end
