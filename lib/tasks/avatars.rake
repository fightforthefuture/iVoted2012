namespace :avatars do
  desc "Revert Avatars"
 	task :revert => :environment do
 	  puts "Preparing to revert the avatar of #{User.count} Users"
 	  i = 0
    User.find_in_batches(:batch_size => 50) do |batch|
      batch.each do |u|
        u.export_image('original')
        i = i+1
        sleep 1
      end
      puts "Reverted #{i} / #{User.count} Users User Avatars"
      sleep 10
    end
    puts "Finished Reverting #{i} / #{User.count} User Avatars"
  end
end