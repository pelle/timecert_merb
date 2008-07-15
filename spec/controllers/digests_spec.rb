require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe Digests, "index action" do
  before(:each) do
    dispatch_to(Digests, :index)
  end
end