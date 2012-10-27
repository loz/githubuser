require 'spec_helper'

describe OrgApp do
  subject { described_class.new :client_class => DummyGithubClient }
  let(:app) { subject }

  describe "Security" do
    it_behaves_like 'restricted resource', :get, '/OrgOne/'
  end

  describe '/:orgid' do
    before(:each) do
      setup_with_user
      get "/OrgOne/"
      @page = last_response.body
    end

    let(:page) { @page }

    it "shows the selected org details" do
      page.should include "OrgOne"
    end

    it "shows the form to fetch user permissions" do
      page.should match form_to "/org/OrgOne/permissions"
      page.should match input_for "username"
    end
  end
end
