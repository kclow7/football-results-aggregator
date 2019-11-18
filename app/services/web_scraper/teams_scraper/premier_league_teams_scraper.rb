require 'nokogiri'
require 'pry'
require 'httparty'
require 'open-uri'

module WebScraper
  module TeamsScraper
    class PremierLeagueTeamsScraper < ApplicationService
      URL = "https://en.as.com/resultados/futbol/inglaterra/equipos/"
      attr_reader :team_infos

      def initialize
        @team_infos = []
      end

      def call
        doc = parse_page(URL)
        teams = get_teams(doc)
        build_team_infos(teams)
        save_team_info
      end

      private

      def parse_page(url)
        unparsed_page = HTTParty.get(url)
        Nokogiri::HTML(unparsed_page)
      end

      def get_teams(doc)
        teams = doc.css('span.escudo')
      end

      def build_team_info(team)
        team_info = {
          name: team.text.strip,
          url: "https:#{team.children[1].attr('src')}"
        }
      end

      def save_team_info
        premier_league_id = League.find_by(name: "Premier League").id
        @team_infos.each do |team_info|
          downloaded_image = open(team_info[:url])
          team = Team.new(name: team_info[:name], league_id: premier_league_id)
          team.crest.attach(io: downloaded_image, filename: "#{team_info[:name]}.png")
          team.save
        end
      end

      def build_team_infos(teams)
        teams.each do |team|
          @team_infos << build_team_info(team)
        end
      end
    end
  end
end
