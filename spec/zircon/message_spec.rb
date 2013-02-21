require "spec_helper"

describe Zircon::Message do
  context 'when message is JOIN message' do
    subject { described_class.new(":example!~example@example.com JOIN :#channel\r\n") }

    describe "#to" do
      its(:to) { should eq('#channel') }
    end
  end

  context 'when message is PRIVMSG message' do
    subject { described_class.new(":example!~example@www35420u.sakura.ne.jp PRIVMSG #channel :body\r\n") }

    describe "#to" do
      its(:to) { should eq('#channel') }
    end

    describe "#body" do
      its(:body) { should eq('body') }
    end
  end
end
