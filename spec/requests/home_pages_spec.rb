require 'spec_helper'

describe "HomePages" do
  describe "GET /" do
    it "displays Welcome Page" do
      get root_path
      response.body.should include("Welcome")
      response.title.should include("gotta fit")
    end
  end
end
