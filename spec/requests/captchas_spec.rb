require 'rails_helper'

RSpec.describe "Captchas", type: :request do
  describe "GET /captchas" do
    it "works! (now write some real specs)" do
      get captchas_path
      expect(response).to have_http_status(200)
    end
  end
end
