require 'helper'
require 'pliable'

describe Pliable do
  it "should have a VERSION constant" do
    Pliable.const_get('VERSION').wont_be_nil
  end
end
