namespace :avatars do
  desc "Revert Avatars"
 	task :revert => :environment do
 	  count = Provider.where(:provider_type=> "twitter").count
 	  puts "Preparing to revert #{count} Avatars"
 	  i = 0
    Provider.where(:provider_type=> "twitter").find_in_batches(:batch_size => 50) do |batch|
      batch.each do |p|
        @client = Twitter::Client.new(:oauth_token => p.token, :oauth_token_secret => p.secret)
        remote_path = @client.user(p.uuid).profile_image_url(:original)
        local_path = p.profile_image_url
        if remote_path.split("/").last == local_path.split("/").last
          puts "Revert Avatar for: #{p.uuid} to: #{p.photos.first.avatar.url}"
          # p.photo.revert_avatar
        else
          puts "Avatar already changed for: #{p.uuid}"
        end
        puts "#{remote_path} :: #{local_path}\n\n"
        i = i+1
        sleep 1
      end
      puts "Reverted #{i} / #{count} Avatars"
      sleep 10
    end
    puts "Finished Reverting #{i} / #{count} Avatars"
  end
end