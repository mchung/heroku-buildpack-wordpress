require 'rspec'
require 'openssl'
require 'httpclient'
require 'nokogiri'

# End-user tests for the heroku-wordpress-buildpack.
#
# These tests run against a public-facing demo site and are intended
# to ensure that all features work as documented.
#
# - Vistors can use HTTP and HTTPS
# - Stylesheet assets are correctly load
# - Security
#   - Default to HTTPS for /wp-admin and /wp-login.php
#   - Forbidden access to /apc and /phpinfo
# - Subdomain hosting
#
# Run tests against demo site with:
# $ rspec test.rb -fd

def client
  http = HTTPClient.new
  http.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
  http
end

def get(url)
  client.get(url, :follow_redirect => true)
end

describe "Wordpress on Heroku" do
  before(:all) do
    # When BLOG_HOME=marcchung.org

    # wtf is up with trailing slashes?
    # /blog/ works
    # /blog redirects
    @host = "marcchung.org/blog/"
    @page = "/hello-wordpress-on-heroku/"

    # heroku config:set BUILDPACK_URL=https://github.com/mchung/heroku-buildpack-wordpress.git#wip/23-host-in-subdir
  end

  describe "visitors" do
    it "can visit the site over HTTP" do
      results = get("http://#{@host}")
      results.status_code.should == 200
      results.http_body.content.should =~ /Wordpress on Heroku/
    end

    it "can visit the site over HTTPS" do
      results = get("https://#{@host}")
      results.status_code.should == 200
      results.http_body.content.should =~ /Wordpress on Heroku/
    end

    it "can visit a blog post over HTTP" do
      results = get("http://#{@host}#{@page}")
      results.status_code.should == 200
      results.http_body.content.should =~ /Hello Wordpress on Heroku | Wordpress on Heroku/
    end

    it "can visit a blog post over HTTPS" do
      results = get("https://#{@host}#{@page}")
      results.status_code.should == 200
      results.http_body.content.should =~ /Hello Wordpress on Heroku | Wordpress on Heroku/
    end
  end

  describe "admin users" do
    describe "visiting /wp-admin over HTTP" do
      it "should be redirected to /wp-login.php over HTTPS" do
        results = get("http://#{@host}wp-admin")
        results.status_code.should == 200

        expected = URI("https://#{@host}wp-login.php")
        results.http_header.request_uri.scheme.should == expected.scheme
        results.http_header.request_uri.host.should == expected.host
        results.http_header.request_uri.path.should == expected.path
      end
    end

    describe "visiting /wp-login.php over HTTP" do
      it "should be redirected to /wp-login.php over HTTPS" do
        results = get("http://#{@host}wp-login.php")
        results.status_code.should == 200

        expected = URI("https://#{@host}wp-login.php")
        results.http_header.request_uri.scheme.should == expected.scheme
        results.http_header.request_uri.host.should == expected.host
        results.http_header.request_uri.path.should == expected.path
      end
    end
  end

  describe "site owners" do
    describe "visiting /apc.php over HTTPS" do
      it "should be forbidden" do # when ENABLE_SYSTEM_ACCESS=false
        results = get("https://#{@host}apc.php")
        results.status_code.should == 403
      end
    end

    describe "visiting /phpinfo.php over HTTPS" do
      it "should be forbidden" do # when ENABLE_SYSTEM_ACCESS=false
        results = get("https://#{@host}apc.php")
        results.status_code.should == 403
      end
    end
  end

  describe "assets" do
    describe "over HTTP" do
      it "should be loaded correctly" do
        doc = Nokogiri::HTML(get("http://#{@host}").body)
        doc.xpath("//link[@rel='stylesheet']").each do |x|
          link = x.attributes["href"].value
          result = client.get(link, :follow_redirect => true)
          result.status_code.should == 200
        end
      end
    end

    describe "over HTTPS" do
      it "should be loaded correctly" do
        doc = Nokogiri::HTML(get("https://#{@host}").body)
        doc.xpath("//link[@rel='stylesheet']").each do |x|
          link = x.attributes["href"].value
          result = client.get(link, :follow_redirect => true)
          result.status_code.should == 200
        end
      end
    end
  end
end


