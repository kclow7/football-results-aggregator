desc "This task updates the matches & highlights."

task :scrape_matches => :environment do
  # scrape matches from all 5 leagues
  League.includes(:matches).all.each do |league|
    total_matches = league.matches.count
    current_matchday = league.matches.map {|match| match.matchday}.max
    matches_played_at_current_matchday = league.matches.where(matchday: current_matchday)
    if league.name == "Bundesliga"
      current_matchday += 1 if matches_played_at_current_matchday.count == 9
    else
      current_matchday += 1 if matches_played_at_current_matchday.count == 10 # when there are 10 matches already, you can move on to next matchday.
    end
    puts "Match scraping begun for matchday #{current_matchday} of #{league.name}"
    league_country_pairs = { "Premier League" => "england", "La Liga" => "spain", "Ligue 1" => "france", "Bundesliga" => "germany", "Serie A" => "italy" }
    WebScraper::MatchesScraper.new(matchday: current_matchday, country: league_country_pairs[league.name]).call
    puts "Match scraping completed for matchday #{current_matchday} of #{league.name}."
    puts "Number of #{league.name} matches before scraping: #{total_matches}."
    puts "Number of #{league.name} matches after scraping: #{league.matches.count}."
    puts "\n"
  end
  puts "Match scraping completed for all leagues."
end

task :search_for_match_highlights => :environment do
  League.includes(:matches).all.each do |league|
    current_matchday = league.matches.map {|match| match.matchday}.max
    puts "Beginning to search for match highlights for matchday #{current_matchday} of #{league.name}."
    YoutubeSearcher.new(matchday: current_matchday, league_name: league.name).call
    puts "Finish searching for match highlights for  matchday #{current_matchday} of #{league.name}."
  end
end
