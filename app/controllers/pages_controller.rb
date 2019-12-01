class PagesController < ApplicationController
  before_action :set_params, only: [:premier_league, :la_liga, :ligue_1, :serie_a, :bundesliga]

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

  def set_params
    action_called = params[:action]
    case action_called
    when "premier_league"
      @league = League.find_by(name: "Premier League")
    when "la_liga"
      @league = League.find_by(name: "La Liga")
    when "serie_a"
      @league = League.find_by(name: "Serie A")
    when "bundesliga"
      @league = League.find_by(name: "Bundesliga")
    else
      @league = League.find_by(name: "Ligue 1")
    end

    @matchday = @league.matches.map {|match| match.matchday}.max
    @all_matchdays = @league.matches.map {|match| match.matchday}.uniq
    @matches = @league.matches.where(matchday: @matchday)
  end

end
