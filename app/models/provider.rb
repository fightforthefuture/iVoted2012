class Provider < ActiveRecord::Base
  
  before_save :on_before_update_or_save
  before_update :on_before_update_or_save
  after_update :follow
    
  attr_accessor :auth_hash
  
  belongs_to :user
  has_many :photos
  

  def photo
    self.photos.last
  end
  
  def avatar
     return self.photos.last.avatar if self.photos.last.avatar.exists?
     return false
  end
  
  def badge
     return self.photos.last.badge if self.photos.last.badge.exists?
     return false
  end
  
  def client
    if self.provider_type == "twitter"
      @client = Twitter::Client.new(:oauth_token => self.token, :oauth_token_secret => self.secret)
    end
  end
  
  def create_photo
    avatar_path = Photo.read_remote_image(self.provider_type, self.uuid, self.profile_image_url)
    avatar = open avatar_path
    photo = Photo.create(
      :provider_type => self.provider_type,
      :provider_uuid => self.uuid,
      :provider_id => self.id,
      :user_id => self.user.id,
      :avatar => avatar
    )
    return photo
  end
  
  def current_photo
    if update_badge?
      return create_photo
    else
      return self.photo
    end
  end
  
  def update_badge?
    if self.provider_type == "twitter"
      @client = Twitter::Client.new(:oauth_token => self.token, :oauth_token_secret => self.secret)
      remote_path = @client.user(self.uuid).profile_image_url(:original)
      remote = remote_path.split("/").last
      local = self.profile_image_url.split("/").last
      update = (local != remote)
      if update
        self.update_attributes(:profile_image_url => remote_path)
      end
    else
      update = false
    end
    if (self.photo.nil? || update)
      return true
    else
      return false
    end
  end
  
  protected

  def on_before_update_or_save
    assign_user
    standard_attributes
    twitter_attributes
    google_attributes
    facebook_attributes
  end

  def assign_user
    if self.user_id.nil?
      self.user_id = User.create(:voted=> false, :pledged => false).id
    end
  end
  
  def standard_attributes
    if !self.auth_hash.nil?
      self.token = self.auth_hash.credentials.token
      self.refresh_token = self.auth_hash.credentials.refresh_token
      self.secret = self.auth_hash.credentials.secret
      self.name =  self.auth_hash.info.name
      self.uuid = self.auth_hash.info.uid
      self.email = self.auth_hash.info.email
      self.nickname = self.auth_hash.info.nickname
      self.first_name = self.auth_hash.info.first_name
      self.last_name = self.auth_hash.info.last_name
      self.location = self.auth_hash.info.location
      self.description = self.auth_hash.info.description
      self.profile_image_url = self.auth_hash.info.image
      self.phone = self.auth_hash.info.phone
      self.urls = self.auth_hash.info.urls
    end
  end
  
  def twitter_attributes
    if !self.auth_hash.nil? && self.provider_type== "twitter"
      info = self.auth_hash.extra.raw_info
      self.uuid = info.screen_name
      self.name = info.name if info.name.blank?
      self.name = info.screen_name if info.screen_name.blank?
      self.id_str = info.id_str
      self.favourites_count = info.favourites_count
      self.followers_count = info.followers_count
      self.friends_count = info.friends_count
      self.statuses_count = info.statuses_count
      self.listed_count = info.listed_count 
      self.verified = info.verified
      self.location = info.location
      self.description = info.description
      self.urls = info.url
      self.profile_background_image_url = info.profile_background_image_url
      self.profile_image_url = self.profile_image_url.gsub("_normal", "")
      self.following = info.following
      self.originated_at = info.created_at
    end
  end
   
  def google_attributes
    if !self.auth_hash.nil? && self.provider_type== "google"
      info =  self.auth_hash.extra.raw_info
      self.uuid = info.id
      self.email = info.email
      self.name = info.name
      self.gender = info.gender
      self.locale = info.locale
      self.id_str = info.id
      self.urls = info.link
      self.profile_image_url = info.picture
      self.verified = info.verified
    end
  end
  
  
  def facebook_attributes
   if !self.auth_hash.nil? && self.provider_type== "facebook"
     info = self.auth_hash.extra.raw_info
     self.uuid = info.id
     self.email = info.email
     self.name = info.name
     self.gender = info.gender
     self.locale = info.locale
     self.id_str = info.id
     self.urls = info.link
     self.profile_image_url = self.profile_image_url.gsub("square", "large")
     self.verified = info.verified
   end
  end

  def follow
    if self.provider_type == "twitter"
       @client = Twitter::Client.new(:oauth_token => self.token, :oauth_token_secret => self.secret)
      if self.following 
        @client.follow("i__voted")
      else
        @client.unfollow("i__voted")
      end
    end
  end
end