require 'rails_helper'

RSpec.describe WebScraper::TeamsScraper do

  describe "#call" do
    context "when TeamsScraper is initialized with a wrong country argument" do
      it "returns error message" do
        team_scraper = WebScraper::TeamsScraper.new(country: "non-existent country")
        expect(team_scraper.call).to eq("Country not available. Unable to perform team scraping.")
      end
    end
  end

  describe "#parse_page" do
    context "when a wrong url is given as argument" do
      it "returns nil" do
        team_scraper = WebScraper::TeamsScraper.new(country: "non-existent country")
        expect(team_scraper.send(:parse_page, "wrong_url")).to eq nil
      end
    end
  end

  describe "#get_teams" do
    context "when argument is not of Nokogiri::HTML class type" do
      it "returns nil" do
        team_scraper = WebScraper::TeamsScraper.new(country: "non-existent country")
        expect(team_scraper.send(:get_teams, "wrong_arg")).to eq nil
      end
    end
  end

end
