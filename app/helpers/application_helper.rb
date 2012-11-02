module ApplicationHelper
  
  def current_uuid
    return "" if !current_provider
    return current_provider.uuid
  end

  def platform_path
    return "/" if !current_user || !current_provider
    return "/#{current_provider.provider_type}/#{current_uuid}"
  end
  
  def edit_platform_path
    return "/" if !current_user || !current_provider
    return "/#{current_provider.provider_type}/#{current_uuid}"
  end
  
  def download_badge_path
     return "/" if !current_user || !current_provider
     return "/photos/#{current_provider.photo.id}/download"
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
    return "Who I voted for President:" if user.voted?
    return "Who I will vote for President:"
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
  
  def personalize(notice)
    notice.
      gsub('CURRENT_LOGIN', current_uuid).
      gsub('DOWNLOAD_BADGE', download_badge_path).
      gsub('PLATFORM_PATH', platform_path).
      gsub('CURRENT_PLATFORM', current_provider.provider_type.capitalize).
      gsub('VOTE_NOTICE', vote_notice)
  end

end
