namespace :avatars do
  desc "Revert Avatars"
 	task :revert => :environment do
 	  count = Provider.where(:provider_type=> "twitter").count
 	  puts "Preparing to revert #{count} Avatars"
 	  i = 0; e= 0; a= 0;
    Provider.where(:provider_type=> "twitter").find_in_batches(:batch_size => 50) do |batch|
      batch.each do |p|
        puts "**** Twitter user:  #{p.uuid}"
        @client = Twitter::Client.new(:oauth_token => p.token, :oauth_token_secret => p.secret) rescue false
        if @client
          remote_path = @client.user(p.uuid).profile_image_url(:original)
          local_path = p.profile_image_url
          if remote_path.split("/").last == local_path.split("/").last
            puts "Revert Avatar for: #{p.uuid} to: #{p.photos.first.avatar.url}"
            puts "#{remote_path} :: #{local_path}\n\n"
            i = i+1
            # p.photo.revert_avatar
          else
           # puts "Avatar already changed for: #{p.uuid}"
           a=a+1
          end
        else
          puts "Expired Token for: #{p.uuid}"
          e=e+1
        end
        sleep 1
      end
      puts "Reverted #{i} / #{count} Avatars. Already Reverted #{a}. Expired tokens #{e}"
      sleep 10
    end
    puts "Finished Reverting #{i} / #{count} Avatars. Already Reverted #{a}. Expired tokens #{e}"
  end
end