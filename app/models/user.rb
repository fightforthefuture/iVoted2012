class User < ActiveRecord::Base
 
  require 'RMagick'
  require 'open-uri'
  require 'net/http'
  
  has_many :posts
  
  attr_accessor :avatar_url, :badge_url, :current_image
  attr_accessible :avatar_url, :badge_url, :avatar, :badge, :twitter_screen_name, :twitter_id, :twitter_name, :twitter_oauth_token, :twitter_oauth_token_secret, :twitter_active, :twitter_badge_style
  has_attached_file :avatar, :styles => { :large => "300x300>",:medium => "128x128>", :thumb => "64x64>" }
  has_attached_file :badge, :styles => { :large => "300x300>",:medium => "128x128>", :thumb => "64x64>" }

  alias_attribute :login, :twitter_screen_name
  
  
  def current_image
    if self.badge.url != "/badges/original/missing.png"
      return self.badge.url
    elsif self.avatar.url != "/badges/original/missing.png"
      return self.avatar.url
    else
      return "defaul_user.jpg"
    end
  end
  
  def self.download_image(url)
    host = URI.parse(url).host
    path = url.gsub("https://", "").gsub("http://", "").gsub(host, "")
    filename = path.split("/").last
    local = "#{Rails.root}/app/assets/images/#{filename}"
    Net::HTTP.start(host) do |http|
        resp = http.get(path)
        open(local, "wb") do |file|
            file.write(resp.body)
        end
    end
    return local
  end
  
  def export_image(badge_overlay)

    overlay = "#{Rails.root}/app/assets/images/#{badge_overlay}.png"
    dst = Magick::Image.read("#{self.avatar.url}").first.scale(300, 300)
    src = Magick::Image.read(overlay).first
    result = dst.composite(src, Magick::SouthEastGravity, Magick::OverCompositeOp).scale(128,128)
    badge_path = "#{Rails.root}/app/assets/images/users/#{self.login}/#{self.login}_badge.jpg"
    result.write(badge_path)
    file= open badge_path
    @client = Twitter::Client.new(:oauth_token => self.twitter_oauth_token, :oauth_token_secret => self.twitter_oauth_token_secret)
    @client.update_profile_image(file)
    if self.update_attributes(:badge => file, :twitter_badge_style => badge_overlay)
      return true
    else
      return false
    end
  end
  
end