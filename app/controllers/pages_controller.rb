class PagesController < ApplicationController
  before_action :set_params, only: [:premier_league, :la_liga, :ligue_1, :serie_a, :bundesliga]
  helper_method :switch_matchday

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

  def switch_matchday(league, matchday)
    url_helpers = Rails.application.routes.url_helpers
    case league
    when "Premier League"
      url_helpers.premier_league_with_matchday_path(matchday)
    when "La Liga"
      url_helpers.la_liga_with_matchday_path(matchday)
    when "Ligue 1"
      url_helpers.ligue_1_with_matchday_path(matchday)
    when "Bundesliga"
      url_helpers.bundesliga_with_matchday_path(matchday)
    when "Serie A"
      url_helpers.serie_a_with_matchday_path(matchday)
    else
      url_helpers.something_is_wrong
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def something_is_wrong
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
    when "ligue_1"
      @league = League.find_by(name: "Ligue 1")
    else
      Rails.application.routes.url_helpers.something_is_wrong
    end

    @all_matchdays = @league.matches.map {|match| match.matchday}.uniq

    if params[:matchday].nil?
      @matchday = @all_matchdays.max
    else
      @matchday = params[:matchday]
    end

    @matches = @league.matches.where(matchday: @matchday)
  end

end
