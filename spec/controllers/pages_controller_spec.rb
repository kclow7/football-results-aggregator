require 'rails_helper'
require 'rails-controller-testing'

RSpec.describe PagesController, :type => :controller do
  describe "set_params" do
    before(:all) do
      @ligue_1 = League.create(name: "Ligue 1")
      @lyon = Team.create(name: "Lyon", league: @ligue_1)
      @psg = Team.create(name: "PSG", league: @ligue_1)
      @monaco = Team.create(name: "Monaco", league: @ligue_1)
      @nice = Team.create(name: "Nice", league: @ligue_1)
      @match_1 = Match.create(league: @ligue_1, team_1: @lyon, team_2: @psg, score_1: 2, score_2: 3, match_date: DateTime.current, matchday: 5)
      @match_2 = Match.create(league: @ligue_1, team_1: @monaco, team_2: @nice, score_1: 0, score_2: 1, match_date: DateTime.current, matchday: 5)
      @match_3 = Match.create(league: @ligue_1, team_1: @nice, team_2: @lyon, score_1: 1, score_2: 1, match_date: DateTime.current, matchday: 7)
    end

    context "when one of the league actions is called, say the ligue_1 action" do
      context "when matchday is included in the GET request" do
        it "sets all params correctly" do
          get :ligue_1, params: { matchday: 5 }
          expect(assigns(:league)).to eq @ligue_1
          expect(assigns(:all_matchdays)).to eq([5, 7])
          expect(assigns(:matchday)).to eq(5)
          expect(assigns(:matches)).to eq([@match_1, @match_2])
        end
      end

      context "when matchday is not included in the GET request" do
        it "sets all params correctly" do
          get :ligue_1
          expect(assigns(:matchday)).to eq(7)
          expect(assigns(:matches)).to eq([@match_3])
        end
      end
    end
  end

  # Don't have to test the case where an inappropriate params[:action] is passed into the controller.
  # Because set_params is only called for the 5 main league actions, all of which are accounted for.
end
