module ApplicationHelper
  
  def current_login
    return "" if !current_user
    return "#{current_user[params[:controller].to_s+'_screen_name']}"
  end

  def platform_path
    return "/" if !current_user
    return "/#{params[:controller]}/#{current_login}" if params[:controller] == "twitter"
  end
  
  def edit_platform_path
    return "/" if !current_user
    return "/#{params[:controller]}/#{current_login}" if params[:controller] == "twitter"
  end
  
  def vote_notice
    return false if !current_user
    return "I Voted" if current_user.voted?
    return "I Pledge to Vote"
  end
  
  def vote_status(user)
    return "Voted!" if user.voted?
    return "Pledged to Vote!"
  end
  
  def vote_for(user)
    return "I voted for President:" if user.voted?
    return "I will vote for President:"
  end
  
  def vote_because(user)
    return "I voted because:" if user.voted?
    return "I will vote because:"
  end
  
  def vote_at(user)
    return "Where I voted:" if user.voted?
    return "Where I will vote:"
  end
  
  def link_to_submit(text, cls)
    link_to_function text, "$(this).closest('form').submit()", :class=> "button #{cls}"
  end

end
