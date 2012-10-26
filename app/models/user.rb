class User < ActiveRecord::Base
 
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

  
  def self.read_remote_image(name, url)
    local_path = "#{TEMP_STORAGE}/#{name}.png"
    host = URI.parse(url).host
    path = url.gsub("https://", "").gsub("http://", "").gsub(host, "")
    conn = Faraday.new(:url => "http://#{host}") do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  Faraday.default_adapter 
    end
    response = conn.get path
    File.open(local_path, 'wb') { |fp| fp.write(response.body) }
    return local_path

  end
  
  def export_image(params)
    badge_overlay = params[:badge]
    overlay = "#{Rails.root}/app/assets/images/#{badge_overlay}.png"
    dst = Magick::Image.read("#{self.avatar.url}").first
    src = Magick::Image.read(overlay).first.scale(dst.columns, dst.rows)
    result = dst.composite(src, Magick::SouthEastGravity, Magick::OverCompositeOp)
    badge_path = "#{TEMP_STORAGE}/#{self.twitter_screen_name}_badge.jpg"
    result.write(badge_path)
    file= open badge_path
    @client = Twitter::Client.new(:oauth_token => self.twitter_oauth_token, :oauth_token_secret => self.twitter_oauth_token_secret)
    @client.update_profile_image(file)
    @client.follow("i__voted") if params[:follow_us] == "1"
    atts = {:badge => file, :twitter_badge_style => badge_overlay, :pledged => !!badge_overlay.match("pledge")}
    atts.merge!(:voted => !!badge_overlay.match("vote")) if !self.voted?
    atts.merge!(:follow_us => true) if params[:follow_us] == "1"
    if self.update_attributes(atts)
      return true
    else
      return false
    end
  end

end