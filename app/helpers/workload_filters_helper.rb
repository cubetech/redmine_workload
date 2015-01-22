# -*- encoding : utf-8 -*-
module WorkloadFiltersHelper
  def get_option_tags_for_userselection(usersToShow, selectedUsers)

    result = '';
    
    usersToShow.sort_by!{ |u| u.name }

    usersToShow.each do |user|
      selected = selectedUsers.include?(user) ? 'selected="selected"' : ''

      result += "<option value=\"#{h(user.id)}\" #{selected}>#{h(user.name)}</option>"
    end

    return result.html_safe
  end


  def group_options()
    available_groups = Group.all
=begin
    if timesheet.groups.first.class == Group
      selected_groups = timesheet.groups.collect{|g| g.id}
    else
      selected_groups = timesheet.groups
    end
    selected_groups = available_groups.collect{|g| g.id} if selected_groups.blank?
=end
    options_from_collection_for_select(available_groups, :id, :name)
  end
end
