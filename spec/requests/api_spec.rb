require 'rails_helper'

RSpec.describe "Apis", type: :request do

  describe "GET /" do
    it "returns a successfull response" do
      VCR.use_cassette('return_successfull_response') do
        get root_path
        expect(response).to have_http_status(:success)
      end
    end

    it "returns a response with the problem and solution" do
      VCR.use_cassette('return_problem_solution') do
        get root_path
        parsed_response = JSON.parse(response.body, {:symbolize_names => true})
        expect(parsed_response).to match({problem: be_kind_of(Array), solution: be_kind_of(Array)})
      end
    end
  end

end
