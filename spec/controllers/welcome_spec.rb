require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe Welcome, "index action" do
  before(:each) do
    dispatch_to(Welcome, :index)
  end
end