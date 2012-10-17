class User < ActiveRecord::Base
 
  require 'RMagick'
  
  has_many :posts
  
  alias_attribute :login, :twitter_screen_name

  
  def remote_avatar_path
     "http://api.twitter.com/1/users/profile_image/#{self.login}.json"
  end
    
  def local_avatar_path
     "users/#{self.login}/#{self.login}_original.jpg"
  end

  def local_badge_path
     "users/#{self.login}/#{self.login}_badge.jpg"
  end

  def download_image
    `mkdir -p #{Rails.root}/app/assets/images/users/#{self.login}`if !File.directory? "#{Rails.root}/app/assets/images/users/#{self.login}"
    `wget #{remote_avatar_path} -O #{Rails.root}/app/assets/images/#{local_avatar_path}`
  end

  def current_badge
    return local_badge_path if File.exists? "#{Rails.root}/app/assets/images/#{local_badge_path}"
    return local_avatar_path if File.exists? "#{Rails.root}/app/assets/images/#{local_avatar_path}"
  end
  
  def export_image(overlay)
    overlay = "#{Rails.root}/app/assets/images/#{overlay}.png"
    dst = Magick::Image.read("#{Rails.root}/app/assets/images/#{local_avatar_path}").first.scale(300, 300)
    src = Magick::Image.read(overlay).first
    result = dst.composite(src, Magick::SouthEastGravity, Magick::OverCompositeOp).scale(128,128)
    result.write("#{Rails.root}/app/assets/images/#{local_badge_path}")
    return "#{Rails.root}/app/assets/images/#{local_badge_path}"
  end

end