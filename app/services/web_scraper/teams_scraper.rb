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

    def initialize(country)
      @team_infos = []
      countries = { "england" => "inglaterra", "spain" => "primera", "germany" => "alemania", "italy" => "italia", "france" => "francia" }
      @league_country = countries[country]
    end

    def call
      url = "https://en.as.com/resultados/futbol/" + @league_country + "/equipos/"
      doc = parse_page(url)
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
      league_names = { "inglaterra" => "Premier League", "primera" => "La Liga", "alemania" => "Bundesliga", "italia" => "Serie A", "francia" => "Ligue 1" }
      league_id = League.find_by(name: league_names[@league_country]).id
      @team_infos.each do |team_info|
        image_file = open(team_info[:url])
        team = ::Team.new(name: team_info[:name], league_id: league_id)
        team.name = check_for_alternate_team_name(team)
        team.crest.attach(io: image_file, filename: "#{team_info[:name]}.png")
        if team.save
          puts "Team: #{team.name}, Status: Successfully saved into database."
        else
          puts "Team: #{team.name}, Status: Failed to save. #{team.errors.full_messages}."
        end
      end
    end

    def build_team_infos(teams)
      teams.each do |team|
        @team_infos << build_team_info(team)
      end
    end

    private

    def check_for_alternate_team_name(team)
      league_name = team.league.name
      case league_name
      when "Bundesliga"
        return check_for_alternate_bundesliga_team_name(team)
      when "Ligue 1"
        return check_for_alternate_ligue_1_team_name(team)
      when "Serie A"
        return check_for_alternate_serie_a_team_name(team)
      else
        return team.name
      end
    end

    def check_for_alternate_bundesliga_team_name(team)
      team_name = team.name
      case team_name
      when "Augsburgo"
        return "Augsburg"
      when "Colonia"
        return "Cologne"
      when "Friburgo"
        return "Freiburg"
      when "Wolfsburgo"
        return "Wolfsburg"
      else
        return team_name
      end
    end

    def check_for_alternate_ligue_1_team_name(team)
      team_name = team.name
      case team_name
      when "Estrasburgo"
        return "Strasbourg"
      when "Niza"
        return "Nice"
      when "Marsella"
        return "Marseille"
      when "Mónaco"
        return "Monaco"
      else
        return team_name
      end
    end

    def check_for_alternate_serie_a_team_name(team)
      team_name = team.name
      case team_name
      when "Nápoles"
        return "Napoli"
      when "Bolonia"
        return "Bologna"
      else
        return team_name
      end
    end
  end
end
