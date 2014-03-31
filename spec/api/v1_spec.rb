require 'spec_helper'

describe "v1 api" do

  context "Properly formed requests" do
    describe "#rule" do
      before(:all) do
        VCR.use_cassette "good_rule" do
          get "/v1/20140301/rule/1-2-2"
          @json = JSON.parse(response.body)
        end
      end

      it "Should return the right number of results" do
        expect(@json['rules'].count).to be 1
      end

      it "Should return the rule number with dots" do
        expect(@json['rules'].first['number']).to eq('1.2.2')
      end

      it "Should return the correct rule text" do
        expect(@json['rules'].first['contents']).to eq('The track surface shall be clean, flat, ' \
                                                      'and suitable for roller skating. Acceptable ' \
                                                      'surfaces include polished or painted concrete' \
                                                      ', wood, or game court floors.')
      end

      it { response.status.should be 200 }
    end

    describe "#rule (splat)" do
      before(:all) do
        VCR.use_cassette "good rule splat" do
          get "/v1/20140301/rule/1-4*"
          @json = JSON.parse(response.body)
        end
      end

      it "Should accept an asterisk at the end" do
        expect(@json['rules'].count).to be 5
      end

      it { response.status.should be 200 }
    end

    describe "#range" do
      before(:each) do
        VCR.use_cassette "good_range" do
          get "v1/20140301/range/1-2-2/1-4"
          @json = JSON.parse(response.body)
        end
      end

      it "Should return the right number of results" do
        expect(@json['rules'].count).to be 13
      end

      it { response.status.should be 200 }
    end

    describe "#glossary" do
      before(:each) do
        VCR.use_cassette "good_glossary" do
          get "v1/20140301/glossary/pass"
        end
      end

      it { response.status.should be 200 }
    end

    describe "#search" do
      before(:each) do
        VCR.use_cassette "good_search" do
          get "v1/20140301/search/star"
        end
      end
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
