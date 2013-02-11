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

  describe "Callback for numeric reply" do
    let(:callback) do
      proc {|msg|}
    end

    let(:zircon) do
      Zircon.new
    end

    before do
      zircon.on_numericreply(&callback)
    end

    context "when triggered event name is number" do
      let(:event) do
        345
      end

      it "should be called" do
        callback.should_receive(:call).with('message')
        zircon.send("trigger_#{event}", 'message')
      end
    end
  end
end
