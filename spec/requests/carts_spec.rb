require 'rails_helper'

RSpec.describe "/carts", type: :request do
  let(:valid_headers) {
    {}
  }

  describe "GET /index" do
    it "renders a successful response" do
      get cart_url(1), headers: valid_headers, as: :json

      expect(response).to be_successful
    end
  end
end
