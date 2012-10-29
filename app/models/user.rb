class User < ActiveRecord::Base
 
  has_many :providers
  has_many :photos
  
  def twitter
    return self.providers.where(:provider_type => "twitter").limit(1).first
  end
  
  def google
    return self.providers.where(:provider_type => "google").limit(1).first
  end
  
  def facebook
    return self.providers.where(:provider_type => "facebook").limit(1).first
  end

############ 
 
  require 'RMagick'
  require 'open-uri'
  require 'net/http'
  
  has_many :posts

  
  attr_accessor :avatar_url, :badge_url, :current_image,:total_followers, :ivoted_badge_count,:ivoted_banner_count,:ipledge_badge_count,:ipledge_banner_count, :original_count
  attr_accessible :avatar_url, :badge_url, :avatar, :badge, :twitter_screen_name, :twitter_id, :twitter_name, :twitter_oauth_token, :twitter_oauth_token_secret, 
  :twitter_active, :twitter_badge_style, :twitter_followers_count, :twitter_listed_count, :twitter_friends_count, :twitter_favourites_count,:total_followers, :ivoted_badge_count,:ivoted_banner_count,:ipledge_badge_count,:ipledge_banner_count, :original_count,
  :i_voted_for_president, :i_voted_because, :where_i_voted_at, :pledged, :voted, :full_name, :show_full_name, :follow_us

  has_attached_file :avatar, :styles => { :large => "300x300>",:medium => "128x128>", :thumb => "64x64>" }
  has_attached_file :badge, :styles => { :large => "300x300>",:medium => "128x128>", :thumb => "64x64>" }

  alias_attribute :login, :twitter_screen_name
  
  #validates_presence_of [:i_voted_for_president, :i_voted_because, :where_i_voted_at], :on => :update_profile

  def update_tokens(token)
    if self.twitter_oauth_token != token.token && self.twitter_oauth_token_secret != token.secret
      self.update_attributes(:twitter_oauth_token => token.token, :twitter_oauth_token_secret => token.secret)
    end
  end
  
  def name
    return self.full_name if self.show_full_name
    return self.twitter_screen_name
  end
    
  def vote_status
    return "I Voted" if self.twitter_badge_style.match("ivoted")
    return "I Pledge to Vote" if self.twitter_badge_style.match("ipledge")
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