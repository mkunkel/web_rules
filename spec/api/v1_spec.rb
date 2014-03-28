require 'spec_helper'

describe "v1 api" do

  context "Properly formed requests" do
    describe "#rule" do
      before(:all) do
        get "/v1/20140301/rule/1-2-2"
        @json = JSON.parse(response.body)
      end

      it "Should return the right number of results" do
        expect(@json['rule'].count).to be 1
      end
      it { response.status.should be 200 }
    end

    describe "#range" do
      before(:each) { get "v1/20140301/range/1-2-2/1-4" }
      it { response.status.should be 200 }
    end

    describe "#glossary" do
      before(:each) { get "v1/20140301/glossary/pass" }
      it { response.status.should be 200 }
    end

    describe "#search" do
      before(:each) { get "v1/20140301/search/star" }
      it { response.status.should be 200 }
    end
  end

  # context "Malformed requests" do
  #   describe "#rule" do
  #     before(:each) { get :rule, release: "20140301", number: "1-2-2" }
  #     it { response.status.should be 200 }
  #   end

  #   describe "#range" do
  #     before(:each) { get :range, release: "20140301", number1: "1-2-2", number2: "1-4" }
  #     it { response.status.should be 200 }
  #   end

  #   describe "#glossary" do
  #     before(:each) { get :glossary, release: "20140301", name: "pass" }
  #     it { response.status.should be 200 }
  #   end

  #   describe "#search" do
  #     before(:each) { get :search, release: "20140301", term: "star" }
  #     it { response.status.should be 200 }
  #   end
  # end
end
