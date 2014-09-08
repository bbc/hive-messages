require "spec_helper"

# Monkey patch == so that our expectations below work correctly
class OpenSSL::X509::Certificate
  def ==(other)
    self.to_s == other.to_s
  end
end

class OpenSSL::PKey::RSA
  def ==(other)
    self.to_s == other.to_s
  end
end

describe Roar::Representer::Transport::NetHTTP::Request do

  describe "class methods" do

    describe ".new" do

      let(:options) { { uri: "http://www.bbc.co.uk" } }
      let(:net_http_double) { double(Net::HTTP, "use_ssl=".to_sym => true, "cert=".to_sym => true, "key=".to_sym => true, "verify_mode=".to_sym => true) }

      before(:each) do
        Hive::Messages.configure do |config|
          configuration_options.each do |option_key, option_value|
            config.send("#{option_key}=", option_value)
          end
        end
        Net::HTTP.stub(new: net_http_double)
        Roar::Representer::Transport::NetHTTP::Request.new(options)
      end

      context "when Hive::Messages is configured to use a client pem_file" do

        let(:pem_file) { File.expand_path("spec/fixtures/sample.pem", Hive::Messages.root) }

        let(:pem) { File.read(pem_file) }
        let(:cert) { OpenSSL::X509::Certificate.new(pem) }
        let(:key) { OpenSSL::PKey::RSA.new(pem) }

        let(:configuration_options) { { pem_file: pem_file, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE } }

        it "turned ssl on" do
          expect(net_http_double).to have_received(:use_ssl=).with(true)
        end

        it "provided a client cert" do
          expect(net_http_double).to have_received(:cert=).with(cert)
        end

        it "provided a client key" do
          expect(net_http_double).to have_received(:key=).with(key)
        end

        it "set the ssl verify mode" do
          expect(net_http_double).to have_received(:verify_mode=).with(configuration_options[:ssl_verify_mode])
        end
      end

      context "when Hive::Messages is NOT configured to use a client pem_file" do

        let(:configuration_options) { {} }

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
