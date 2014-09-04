require "spec_helper"

describe Roar::Representer::Transport::NetHTTP::Request do

  describe "class methods" do

    describe ".new" do

      let(:options) { {uri: "http://www.bbc.co.uk"} }
      let(:net_http_double) { double(Net::HTTP, "use_ssl=".to_sym => true, "cert=".to_sym => true, "key=".to_sym => true, "verify_mode=".to_sym => true ) }

      before(:each) do
        Net::HTTP.stub(new: net_http_double)
        Roar::Representer::Transport::NetHTTP::Request.new(options)
      end

      context "when Hive::Messages is configured to use a client pem_file" do

      end

      context "when Hive::Messages is NOT configured to use a client pem_file" do

        it "did not turn ssl on" do
          expect(net_http_double).to_not have_received(:use_ssl=)
        end

        it "did not provide a cert" do
          expect(net_http_double).to_not have_received(:cert=)
        end

        it "did not provide a key" do
          expect(net_http_double).to_not have_received(:key=)
        end

        it "did not set an ssl verify mode" do
          expect(net_http_double).to_not have_received(:verify_mode=)
        end
      end
    end
  end
end
