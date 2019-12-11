# allows for manual scraping of a matchday & its matches' Youtube videos in just 1 line.
class FullScraper < ApplicationService
  def initialize(country:, matchday:)
    @matchday = matchday
    @country = country
  end

  def call
    puts "Beginning full scraper for matchday #{@matchday} in #{@country}."
    WebScraper::MatchesScraper.new(matchday: @matchday, country: @country).call
    league_names = { "england" => "Premier League", "spain" => "La Liga", "germany" => "Bundesliga", "italy" => "Serie A", "france" => "Ligue 1" }
    YoutubeSearcher.new(matchday: @matchday, league_name: league_names[@country]).call
    puts "Completed full scraper for matchday #{@matchday} in #{@country}."
  end
end
