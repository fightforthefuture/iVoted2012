class User < ActiveRecord::Base
 
  has_many :providers
  has_many :photos
  has_many :posts
  
  attr_accessible :pledged, :voted, :badge_type, :i_voted_for_president, :i_voted_because, :where_i_voted_at
    
  def twitter
    return self.providers.where(:provider_type => "twitter").limit(1).first
  end
  
  def google
    return self.providers.where(:provider_type => "google").limit(1).first
  end
  
  def facebook
    return self.providers.where(:provider_type => "facebook").limit(1).first
  end

  def vote_status
    return "I Voted" if self.badge_type.match("ivoted")
    return "I Pledge to Vote" if self.badge_type.match("ipledge")
  end
  
  def current_image
    if self.badge.url != "/badges/original/missing.png"
      return self.badge.url
    elsif self.avatar.url != "/badges/original/missing.png"
      return self.avatar.url
    else
      return "defaul_user.jpg"
    end
  end

end