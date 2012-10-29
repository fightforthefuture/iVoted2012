namespace :users do
  desc "Migrate Users to new system"
  task :migrate => :environment do
 	  count = User.count
 	  puts "Preparing to migrate #{count} Users"
 	  i = 0
    User.find_in_batches(:batch_size => 50) do |batch|
      batch.each do |u|
        p = Provider.create(
          :user_id => u.id,
          :provider_type => "twitter",
          :token => u.twitter_oauth_token,
          :secret => u.twitter_oauth_token_secret,
          :uuid => u.twitter_screen_name,
          :id_str => u.twitter_id,
          :name => u.full_name,
          :active => u.twitter_active,
          :badge_type => u.twitter_badge_style,
          :followers_count => u.twitter_followers_count,
          :listed_count => u.twitter_listed_count,
          :friends_count => u.twitter_friends_count,
          :favourites_count => u.twitter_favourites_count,
          :following => u.follow_us,
          :profile_image_url => u.avatar.url
        )
        p.photo.update_attributes(:badge_type => u.twitter_badge_style)
        i = i+1
      end
      puts "Migrating #{i} / #{count} User"
      sleep 10
    end
    puts "Finished Migrating #{i} / #{count} User"
  end
end