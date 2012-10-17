class Settings < Settingslogic
  source "#{Rails.root}/config/settings.yml"
  namespace Rails.env
  
  def self.default_tweet
    "#iVoted2012, I just voted and got my own iVoted2012.org profile page. Join me and pledge your vote."
  end

  def self.overlay_options
    [{:name => 'full_badge', :title=> "Full Image Badge", :description=> "Replace your avatar with a full iVoted2012.org Badge"},
      {:name => 'banner_badge', :title=> "Banner Badge Overlay", :description=> "An overlay badge on of your current twitter avatar."},
      {:name => 'original', :title=> "No Badge", :description=> "Your original twitter avatar."}]
  end
end