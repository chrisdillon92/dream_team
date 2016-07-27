class TeamsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @teams = Team.all
  end

  def show
    @team = Team.find(params[:id])
    @roster = Roster.new
    @my_roster = @team.rosters.find_by(user_id: current_user)
    # @roster = Roster.find_by(user_id: current_user.id)
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)

    if @team.update_attributes(team_params)
      Roster.create(team_id: @team.id, user_id: current_user.id, is_owner: true)
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update

    @team = Team.find(params[:id])

  if @team.update_attributes(team_params)
    redirect_to team_path
  else
    render :edit
  end #if block

  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy
    redirect_to teams_path
  end
# create default for is_owner (false)
  def join_team
    @team = Team.find(params[:team_id])
    @roster = @team.rosters.new(params.require(:roster).permit(:is_owner, :user_id, :team_id))
    @roster.user = current_user
    if @roster.save
      redirect_to team_path(@team)
    else
      redirect_to root_path
    end
  end

  def leave_team
    # user = User.find_by(name: 'David')
    # user.destroy
    @team = Team.find(params[:id]) # the current team that the user wants to leave
    @roster = @team.rosters.find_each(user_id: current_user) # the roster representing the user's membership in the team
    # @roster.destroy
    # @roster = @team.rosters.find_by(user_id: current_user).user_id

  end

  private

  def team_params
    params.require(:team).permit(:name, :tag, :mission, :image)
  end
end
