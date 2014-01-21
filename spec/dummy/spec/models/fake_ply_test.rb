require "spec_helper"

describe Ply do
  before do
    @ply = FakePly.new
  end

  it "must be valid" do
    # @ply.valid?.must_equal true
    @ply.save.must_equal true
  end
end
