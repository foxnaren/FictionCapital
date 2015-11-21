desc "Used to test single instance"
task :singletest => :environment do

	@lightnovel = Lightnovel.all
	@lightnovel.each do |lightnovel|
		count = lightnovel.chapters.count
		puts "#{count}"
		lightnovel.update_attributes(:number_of_chapters => count)
	end

end