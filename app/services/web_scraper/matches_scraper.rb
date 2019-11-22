require 'nokogiri'
require 'pry'
require 'httparty'
require 'open-uri'

module WebScraper
  class MatchesScraper < ApplicationService
    def initialize(country:, matchday:)
      @matchday = matchday.to_s
      countries = { "england" => "inglaterra", "spain" => "primera", "germany" => "alemania", "italy" => "italia", "france" => "francia" }
      @league_country = countries[country]
      @match_infos = []
    end

    def call
      url = set_url
      doc = parse_page(url)
      matches = get_matches(doc)
      build_match_infos(matches)
      save_match_info
    end

    private

    def set_url
      url = "https://en.as.com/resultados/futbol/" + @league_country + "/2019_2020/jornada/regular_a_" + @matchday
    end

    def parse_page(url)
      unparsed_page = HTTParty.get(url)
      Nokogiri::HTML(unparsed_page)
    end

    def get_matches(doc)
      doc.css('li.list-resultado')
    end

    def build_match_infos(matches)
      set_league
      matches.each do |match|
        @match_infos << build_match_info(match)
      end
    end

    def build_match_info(match)
      team_1 = match.css('span.nombre-equipo')[0].text
      team_2 = match.css('span.nombre-equipo')[1].text
      results = match.css('a.resultado').text.strip
      return if results == "-"
      score_1 = results[0..1].strip.to_i
      score_2 = results[4..results.length].strip.to_i
      match_info = {
        team_1: Team.find_by(name: team_1),
        team_2: Team.find_by(name: team_2),
        score_1: score_1,
        score_2: score_2,
        match_date: get_match_date(match),
        league: @league,
        matchday: @matchday.to_i
      }
    end

    def save_match_info
      @match_infos.each do |match_info|
        ::Match.create(match_info)
      end
    end

    def set_league
      league_names = { "inglaterra" => "Premier League", "primera" => "La Liga", "alemania" => "Bundesliga", "italia" => "Serie A", "francia" => "Ligue 1" }
      @league = League.find_by(name: league_names[@league_country])
    end

    def get_match_date(match)
      match_date_and_time_in_string = match.css('span.fecha').text.chars.last(11).join
      match_date_in_string = match_date_and_time_in_string[0..4]
      year = DateTime.now.year
      month = match_date_in_string[3..4].to_i
      day = match_date_in_string[0..1].to_i
      match_date = Date.new(year, month, day)
    end
  end
end
