require "rails_helper"

RSpec.describe DdconfigsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/ddconfigs").to route_to("ddconfigs#index")
    end

    it "routes to #show" do
      expect(:get => "/ddconfigs/1").to route_to("ddconfigs#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/ddconfigs").to route_to("ddconfigs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/ddconfigs/1").to route_to("ddconfigs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/ddconfigs/1").to route_to("ddconfigs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/ddconfigs/1").to route_to("ddconfigs#destroy", :id => "1")
    end
  end
end
