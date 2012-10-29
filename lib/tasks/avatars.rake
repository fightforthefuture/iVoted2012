namespace :avatars do
  desc "Revert Avatars"
 	task :revert => :environment do
 	  count = Photo.where(:uploaded=> true).count
 	  puts "Preparing to revert #{count} Avatars"
 	  i = 0
    Photo.where(:uploaded=> true).find_in_batches(:batch_size => 50) do |batch|
      batch.each do |p|
        p.revert_avatar
        i = i+1
        sleep 1
      end
      puts "Reverted #{i} / #{count} Avatars"
      sleep 10
    end
    puts "Finished Reverting #{i} / #{count} Avatars"
  end
end