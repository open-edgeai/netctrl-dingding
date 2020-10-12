require 'rails_helper'

RSpec.describe "Ddconfigs", type: :request do
  describe "GET /ddconfigs" do
    it "works! (now write some real specs)" do
      get ddconfigs_path
      expect(response).to have_http_status(200)
    end
  end
end
