require "spec_helper"

describe Zircon do
  describe "#run!" do
    it "should try to login and wait message from server" do
      Zircon.any_instance.should_receive(:login)
      Zircon.any_instance.should_receive(:wait_message)
      Zircon.new.run!
    end
  end

  describe "#wait_message" do
    it "should trigger callback related to message type" do
      message = mock
      message.stub(:type).and_return("xxx")
      Zircon::Message.stub(:new).and_return(message)
      Zircon.any_instance.stub(:loop) { |&block| block.call }
      Zircon.any_instance.stub(:login)
      Zircon.any_instance.stub(:gets)
      Zircon.any_instance.should_receive(:trigger_xxx).with(message)
      Zircon.new.run!
    end
  end

  describe "IRC command method (#join, #kick, #notice, ...)" do
    it "should write type and args in space-separated form to socket" do
      Zircon.any_instance.should_receive(:write).with("PRIVMSG channel :message\r\n")
      Zircon.new.privmsg("channel", ":message")
    end
  end
end
