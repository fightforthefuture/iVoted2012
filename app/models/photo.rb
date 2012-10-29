class Photo < ActiveRecord::Base
  
  require 'RMagick'
  require 'open-uri'
  require 'net/http'
  
  has_attached_file :avatar, :styles => { :large => "300x300>",:medium => "128x128>", :thumb => "64x64>" }
  has_attached_file :badge, :styles => { :large => "300x300>",:medium => "128x128>", :thumb => "64x64>" }

  attr_accessor :voted, :pledged, :following
  
  belongs_to :provider
  belongs_to :user  

  before_update :update_badge
  before_update :update_user
  before_update :update_provider

  def self.read_remote_image(provider_type, uuid, url)
    local_path = "#{TEMP_STORAGE}/#{provider_type}_#{uuid}.png"
    response = Photo.read_remote_location(url) 
    if response.body.blank? && !response.headers.nil?
      response = Photo.read_remote_location(response.headers["location"])
    end
    File.open(local_path, 'wb') { |fp| fp.write(response.body) }
    return local_path
  end
  
  def self.read_remote_location(url)
    host = URI.parse(url).host
    path = url.gsub("https://", "").gsub("http://", "").gsub(host, "")
    conn = Faraday.new(:url => "http://#{host}") do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  Faraday.default_adapter 
    end
    response = conn.get path
    return response
  end
  
  def self.create_badge(badge_type, provider_type, provider_uuid, url)
    overlay = "#{Rails.root}/app/assets/images/#{badge_type}.png"
    dst = Magick::Image.read("#{url}").first
    src = Magick::Image.read(overlay).first.scale(dst.columns, dst.rows)
    result = dst.composite(src, Magick::SouthEastGravity, Magick::OverCompositeOp)
    local_path = "#{TEMP_STORAGE}/#{provider_type}_#{provider_uuid}_#{badge_type}.jpg"
    result.write(local_path)
    return local_path
  end
  
  def update_badge
    badge_path = Photo.create_badge(self.badge_type, self.provider_type, self.provider_uuid, self.avatar.url)
    badge = open badge_path
    self.uploaded = self.upload_image(badge)
    self.badge = badge
  end
  
  def update_user
    atts = {:twitter_badge_style => self.badge_type, :pledged => !!self.badge_type.match("pledge")}
    atts.merge!(:voted =>  !!self.badge_type.match("vote")) if !!self.badge_type.match("vote") && !self.user.voted
    self.provider.user.update_attributes(atts)
  end
  
  def update_provider
    atts = {:badge_type=> self.badge_type}
    atts.merge!(:following => (self.following == "1")) if !self.following.blank?
    self.provider.update_attributes(atts)
  end

  def upload_image(file)
    if self.provider.provider_type == "twitter"
      @client = Twitter::Client.new(:oauth_token => self.provider.token, :oauth_token_secret => self.provider.secret)
      @client.update_profile_image(file)
      return true
    else
      return false
    end
  end

  def revert_avatar
    if self.uploaded
      file = open Photo.read_remote_image(self.provider.provider_type, self.provider.uuid, self.avatar.url)
      if self.provider_type == "twitter"
        @client = Twitter::Client.new(:oauth_token => provider.token, :oauth_token_secret => provider.secret)
        @client.update_profile_image(file)
      end
    end
  end
end
