class PagesController < ApplicationController
  before_action :set_matchday, only: [:premier_league, :la_liga, :ligue_1, :serie_a, :bundesliga]

  def deprecated_home
  end

  def home
  end

  def premier_league
  end

  def la_liga
  end

  def ligue_1
  end

  def bundesliga
  end

  def serie_a
  end

  private

  def set_matchday
    if params[:matchday].nil?
      action_called = params[:action]
      case action_called
      when "premier_league"
        @matchday = League.find_by(name: "Premier League").matches.map {|match| match.matchday}.max
      when "la_liga"
        @matchday = League.find_by(name: "La Liga").matches.map {|match| match.matchday}.max
      when "serie_a"
        @matchday = League.find_by(name: "Serie A").matches.map {|match| match.matchday}.max
      when "bundesliga"
        @matchday = League.find_by(name: "Bundesliga").matches.map {|match| match.matchday}.max
      else
        @matchday = League.find_by(name: "Ligue 1").matches.map {|match| match.matchday}.max
      end
    else
      @matchday = params[:matchday]
    end
  end

end
