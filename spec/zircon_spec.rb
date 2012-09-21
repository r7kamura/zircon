require "spec_helper"

describe Zircon do
  describe "#initialize" do
    it do
      Zircon.new.should be_a(Zircon)
    end
  end
end
