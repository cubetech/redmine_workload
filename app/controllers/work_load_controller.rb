# -*- encoding : utf-8 -*-
class WorkLoadController < ApplicationController

  unloadable

  helper :gantt
  helper :issues
  helper :projects
  helper :queries
  helper :workload_filters

  include QueriesHelper

  def show
    workloadParameters = params[:workload] || {}

    @first_day = sanitizeDateParameter(workloadParameters[:first_day],  Date::today - 10)
    @last_day  = sanitizeDateParameter(workloadParameters[:last_day],   Date::today + 50)
    @today     = sanitizeDateParameter(workloadParameters[:start_date], Date::today)

    # Make sure that last_day is at most 12 months after first_day to prevent
    # long running times
    @last_day = [(@first_day >> 12) - 1, @last_day].min
    @timeSpanToDisplay = @first_day..@last_day

    initalizeUsers(workloadParameters)

    @issuesForWorkload = ListUser::getOpenIssuesForUsers(@usersToDisplay)
    @monthsToRender = ListUser::getMonthsInTimespan(@timeSpanToDisplay)
    @workloadData   = ListUser::getHoursPerUserIssueAndDay(@issuesForWorkload, @usersToDisplay, @timeSpanToDisplay, @today)
  end


  private

  def initalizeUsers(workloadParameters)

    # Get list of users that are allowed to be displayed by this user
    @usersAllowedToDisplay = ListUser::getUsersAllowedToDisplay()

    if  workloadParameters[:group] &&  !workloadParameters[:group].empty?
      userIds = Group.find(workloadParameters[:group]).users.collect { |user| user.id}
    else
      userIds = workloadParameters[:users].kind_of?(Array) ? workloadParameters[:users] : []
    end
    userIds.map! { |x| x.to_i }

    # Get list of users that should be displayed.
    @usersToDisplay = User.find_all_by_id(userIds)

    # Intersect the list with the list of users that are allowed to be displayed.
    @usersToDisplay = @usersToDisplay & @usersAllowedToDisplay
  end

  def sanitizeDateParameter(parameter, default)

    if (parameter.respond_to?(:to_date)) then
      return parameter.to_date
    else
      return default
    end
  end
end
