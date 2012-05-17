require 'spec_helper'

describe "HomePages" do
  describe "GET /" do
    let(:base_title) {'gotta fit'}
    it "displays Welcome Page" do
      get root_path
      response.body.should include('gotta_fit')
      response.body.should include('home')
    end
  end
end
