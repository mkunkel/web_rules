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
          get "v1/20140301/glossary/initiator"
          @json = JSON.parse(response.body)
        end
      end

      it "Should return the right number of results" do
        expect(@json['entries'].count).to be 2
      end

      it "Should format results correctly" do
        expected = {"name" => "Initiator of the Assist",
                    "definition" => "The skater who reaches for, grabs, and/or" \
                    " pushes a teammate in order to help that teammate. A " \
                    "skater may also take an assist off of a teammate’s body," \
                    " and would be initiating their own assist."
                   }
        expect(@json['entries'].first).to eq(expected)
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

  context "File management" do
    describe "File does not exist" do
      before(:each) do
        @rules_file = "#{Rails.root}/lib/assets/rules/20140301_rules.html"
        @glossary_file = "#{Rails.root}/lib/assets/rules/20140301_glossary.html"
        FileUtils.rm @rules_file if File.exists?(@rules_file)
        FileUtils.rm @glossary_file if File.exists?(@glossary_file)
      end

      it "Should create a rules file" do
        VCR.use_cassette "good_rule" do
          get "/v1/20140301/rule/1-2-2"
        end
        expect(File.exists?(@rules_file)).to be true
      end

      it "Should create a glossary file" do
        VCR.use_cassette "good_rule" do
          get "/v1/20140301/rule/1-2-2"
        end
        expect(File.exists?(@glossary_file)).to be true
      end
    end

    describe "File exists" do
      before(:each) do
        @rules_file = "#{Rails.root}/lib/assets/rules/20140301_rules.html"
        @glossary_file = "#{Rails.root}/lib/assets/rules/20140301_glossary.html"
        FileUtils.touch @rules_file unless File.exists?(@rules_file)
        FileUtils.touch @glossary_file unless File.exists?(@glossary_file)
      end

      after(:each) do
        Timecop.return
      end

      it "Should create a new rules file if more than 7 days old" do
        before_time = File.mtime(@rules_file)
        Timecop.travel(Date.today + 8)
        VCR.use_cassette "good_rule" do
          get "/v1/20140301/rule/1-2-2"
        end
        after_time = File.mtime(@rules_file)
        expect(before_time).not_to eq(after_time)
      end

      it "Should not create a new rules file if less than 7 days old" do
        before_time = File.mtime(@rules_file)
        Timecop.travel(Date.today + 6)
        VCR.use_cassette "good_rule" do
          get "/v1/20140301/rule/1-2-2"
        end
        after_time = File.mtime(@rules_file)
        expect(before_time).to eq(after_time)
      end

      it "Should create a new glossary file if more than 7 days old" do
        before_time = File.mtime(@glossary_file)
        Timecop.travel(Date.today + 8)
        VCR.use_cassette "good_rule" do
          get "/v1/20140301/rule/1-2-2"
        end
        after_time = File.mtime(@glossary_file)
        expect(before_time).not_to eq(after_time)
      end

      it "Should not create a new glossary file if less than 7 days old" do
        before_time = File.mtime(@glossary_file)
        Timecop.travel(Date.today + 6)
        VCR.use_cassette "good_rule" do
          get "/v1/20140301/rule/1-2-2"
        end
        after_time = File.mtime(@glossary_file)
        expect(before_time).to eq(after_time)
      end
    end
  end
end
