require 'spec_helper'

describe MainApp do
  subject { described_class.new :client_class => DummyGithubClient }
  let(:app) { subject }

  describe '/' do
    context "when logged in" do
      before :each do
        setup_with_user
        get '/'
      end

      it "renders the welcome page" do
        last_response.should be_ok
        last_response.body.should include "Welcome to Github Org User Managment"
      end

      it "indicates the user logged in name" do
        last_response.body.should include user[:name]
      end


      it "shows all the user's organizations" do
        page = last_response.body
        page.should match link_to "/OrgOne/", "OrgOne"
        page.should match link_to "/OrgTwo/", "OrgTwo"
      end

    end

    context "when not logged in" do
      before :each do
        get '/'
      end

      it "renders the sign in message" do
        last_response.body.should include "/auth/github"
      end
    end
  end

  describe '/auth/github/callback' do
    before :each do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:github, {
        :uid => 1234,
        :info => {
          :nickname => 'github_user',
          :email => 'joe@blogs.com'
        },
        :credentials => {
          :token => 'agithubtoken'
        }
      })
      get '/auth/github/callback?code=foo'
    end

    it "adds the user to the session" do
      user = last_request.session[:user]
      user[:uid].should == '1234'
      user[:name].should == 'github_user'
      user[:token].should == 'agithubtoken'
    end

    it "redirects to /" do
      last_response.should be_redirect
      last_response.location.should == 'http://example.org/'
    end
  end
end
