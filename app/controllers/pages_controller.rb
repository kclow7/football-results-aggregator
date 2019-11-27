class PagesController < ApplicationController
  before_action :set_matchday, only: [:premier_league, :ligue_1, :la_liga, :bundesliga, :serie_a]

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
    @matchday = params[:matchday]
  end
end
