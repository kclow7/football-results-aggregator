require 'nokogiri'
require 'pry'
require 'httparty'
require 'open-uri'
require 'mini_magick'

module WebScraper
  class TeamsScraper < ApplicationService
    OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
    OpenURI::Buffer.const_set 'StringMax', 0
    attr_reader :team_infos

    def initialize(country:)
      @team_infos = []
      countries = { "england" => "inglaterra", "spain" => "primera", "germany" => "alemania", "italy" => "italia", "france" => "francia" }
      @league_country = countries[country]
    end

    def call
      return "Country not available. Unable to perform team scraping." if @league_country.nil?
      # scrape from each league table's page.
      url = "https://en.as.com/resultados/futbol/#{@league_country}/clasificacion/"
      doc = parse_page(url)
      teams = get_teams(doc)
      return "Unable to get teams." if teams.nil?
      build_team_infos(teams)
      save_team_info
    end

    private

    def parse_page(url)
      begin
        unparsed_page = HTTParty.get(url)
      rescue Errno::ECONNREFUSED => e
        puts "Rescued: #{e.message}"
        puts "Wrong URL, unable to parse the page."
        return
      end
      Nokogiri::HTML(unparsed_page)
    end

    def get_teams(doc)
      begin
        teams = doc.css('th.cont-nombre-equipo[itemtype="http://schema.org/SportsTeam"]')
      rescue NoMethodError => e
        puts "Rescued: #{e.message}"
        return
      end
    end

    def build_team_infos(teams)
      teams.each do |team|
        @team_infos << build_team_info(team)
      end
    end

    def build_team_info(team)
      team_info = {
        name: team.css('span.nombre-equipo').text.strip,
        url: "https:#{team.css('img').attr('data-src')}".gsub("x-small", "large")
      }
    end

    def save_team_info
      league_names = { "inglaterra" => "Premier League", "primera" => "La Liga", "alemania" => "Bundesliga", "italia" => "Serie A", "francia" => "Ligue 1" }
      league_id = League.find_by(name: league_names[@league_country]).id
      @team_infos.each do |team_info|
        image_file = open(team_info[:url])
        team = ::Team.new(name: team_info[:name], league_id: league_id)
        team.crest.attach(io: image_file, filename: "#{team_info[:name]}.png")
        if team.save
          puts "Team: #{team.name}; Status: Successfully saved into database."
          puts "   "
        else
          puts "Team: #{team.name}; Status: Failed to save. #{team.errors.full_messages}."
          puts "   "
        end
      end
    end

  end
end
