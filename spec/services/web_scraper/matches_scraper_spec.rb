require 'rails_helper'

RSpec.describe WebScraper::MatchesScraper do
  describe "#call" do
    context "when matchday input is not an integer" do
      it "return error message" do
        ms = WebScraper::MatchesScraper.new(country: "england", matchday: "not an integer")
        expect(ms.call).to eq "Matchday must be an integer."
      end
    end

    context "when matchday input is integer larger than 38" do
      it "return error message" do
        ms = WebScraper::MatchesScraper.new(country: "england", matchday: 39)
        expect(ms.call).to eq "Matchday must be between 1 and 38, inclusive."
      end
    end

    context "when a wrong country input is given" do
      it "return error message" do
        ms = WebScraper::MatchesScraper.new(country: "englandddd", matchday: 4)
        expect(ms.call).to eq "Country not available. Unable to perform match scraping."
      end
    end
  end

  describe "#parse_page" do
    context "when a wrong url is given as argument" do
      it "returns nil" do
        ms = WebScraper::MatchesScraper.new(country: "non-existent country", matchday: 5)
        expect(ms.send(:parse_page, "wrong_url")).to eq nil
      end
    end
  end

  describe "#get_matches" do
    context "when argument is not of Nokogiri::HTML class type" do
      it "returns nil" do
        ms = WebScraper::MatchesScraper.new(country: "non-existent country", matchday: 5)
        expect(ms.send(:get_matches, "wrong_arg")).to eq nil
      end
    end
  end

end
