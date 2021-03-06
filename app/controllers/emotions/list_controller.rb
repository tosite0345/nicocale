# frozen_string_literal: true

class Emotions::ListController < ApplicationController
  before_action :joined?
  # before_action :set_month
  # before_action :set_team_users

  # GET /teams/1
  # GET /teams/1.json
  def show
    @team          = Team.find(params[:team_id])
    @month         = Date.parse("#{params[:id]}01")
    @team_users    = TeamUser.eager_load(:user).team_id(@team.id).all
    @own_emotions  = UserEmotion.e.team_id(@team.id).user_id(current_user.id).on_between(@month).all
    @calendar      = {}
    @me            = current_user.team_users.team_id(@team.id).first
    @team_users.each { |u| @calendar[u.user_id] = set_calendar(@month, u, @team.id) }
  end

  private
    def joined?
      unless TeamUser.joined?(team_id: params[:team_id], user_id: current_user.id)
        respond_to do |format|
          format.html { redirect_back_page(alerts: "404") }
          format.json { render json: @team.errors, status: :unprocessable_entity }
        end
      end
    end

    def set_calendar(month, team_user, team_id)
      calendar = {}
      (month..month.end_of_month).each { |day| calendar[day.strftime("%Y-%m-%d")] = {} }
      emotions = team_user.user_emotions.e.on_between(@month).all
      emotions.each { |e| calendar[e.reported_on.strftime("%Y-%m-%d")] = e }
      calendar
    end
end
