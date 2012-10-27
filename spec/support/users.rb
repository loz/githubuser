def setup_with_user
  rack_session[:user] = {}
  rack_session[:user][:uid] = '1234'
  rack_session[:user][:name] = "Mr User"
  rack_session[:user][:token] = "a_github_token"
end

def user
  rack_session[:user] || {}
end

shared_examples_for 'restricted resource' do |method, action|
  context "when user is logged in" do
    before :each do
      setup_with_user
      public_send(method, action)
    end

    it "does not redirect to '/'" do
      last_response.location.should_not == 'http://example.org/'
    end
  end

  context "when user is not logged in" do
    before :each do
      public_send(method, action)
    end

    it "redirects to '/'" do
      last_response.should be_redirect
      last_response.location.should == 'http://example.org/'
    end
  end
end
