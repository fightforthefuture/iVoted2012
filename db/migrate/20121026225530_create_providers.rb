class CreateProviders < ActiveRecord::Migration
  def self.up
     create_table :providers do |t|
       t.integer  :user_id
       t.string   :provider_type,     :null=> false
       t.string   :token,             :null=> false
       t.string   :refresh_token
       t.string   :secret
       t.string   :uuid,              :unique => true
       t.string   :name
       t.string   :id_str
       t.string   :email
       t.string   :nickname
       t.string   :first_name
       t.string   :last_name
       t.string   :location
       t.string   :description
       t.string   :profile_image_url
       t.string   :profile_background_image_url
       t.string   :phone
       t.text     :urls
       t.string   :gender
       t.string   :locale
       t.boolean  :verified,          :default => false
       t.boolean  :active,            :default => false
       t.boolean  :following,         :default => false
       t.integer  :followers_count,   :default => 0
       t.integer  :friends_count,     :default => 0
       t.integer  :favourites_count,  :default => 0
       t.integer  :listed_count,      :default => 0
       t.integer  :statuses_count,    :default => 0
       t.text     :extra
       t.string   :badge_type, :default => "original"
       t.datetime :originated_at
       t.timestamps
     end
   end

   def self.down
     drop_table :providers
   end
end