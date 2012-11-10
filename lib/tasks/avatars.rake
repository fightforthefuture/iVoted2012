namespace :avatars do
  desc "Revert Avatars"
 	task :revert => :environment do
 	  count = Provider.where(:provider_type=> "twitter").count
 	  puts "Preparing to revert #{count} Avatars"
 	  i = 0; e= 0; a= 0;r= 0;
    Provider.where(:provider_type=> "twitter").find_in_batches(:batch_size => 50) do |batch|
      batch.each do |p|
        @client = Twitter::Client.new(:oauth_token => p.token, :oauth_token_secret => p.secret)
        remote_path = @client.user(p.uuid).profile_image_url(:original) rescue false
        if remote_path
          local_path = p.profile_image_url
          if remote_path.split("/").last == local_path.split("/").last
            puts "Revert Avatar for: #{p.uuid} to: #{p.photos.first.avatar.url}"
            puts "#{remote_path} :: #{local_path}\n\n"
            p.photos.first.revert_avatar
            r=r+1
          else
           # puts "Avatar already changed for: #{p.uuid}"
           a=a+1
          end
        else
          #puts "Expired Token for: #{p.uuid}"
          e=e+1
        end
        i = i+1
        sleep 1
      end
      puts "Processed #{i} / #{count} Avatars. Reverted #{r}. Already Reverted #{a}. Expired tokens #{e}"
      sleep 10
    end
    puts "Finished Processing #{i} / #{count} Avatars. Reverted #{r}. Already Reverted #{a}. Expired tokens #{e}"
  end
end