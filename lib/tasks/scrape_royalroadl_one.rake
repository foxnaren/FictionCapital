desc "Fetch Royalroadl Links"
task :fetch_royalroadl_one => :environment do

	require 'rubygems'
	require 'feedjira'
	require 'nokogiri'
	require 'open-uri'

	for fictionID in 500..505
		
		url_feed = "http://royalroadl.com/forum/syndication.php?fid=#{fictionID}"
		url_nok = "http://royalroadl.com/fiction/#{fictionID}"

		puts ">>>>>url-feed>>>#{url_feed}<<<<"
		puts ">>>>url-nok>>>#{url_nok}<<<<<"
		
		feed = Feedjira::Feed.fetch_and_parse url_feed
		doc = Nokogiri::HTML(open(url_nok))
		
		count = feed.entries.count

		#puts ">>>feed>>>>>>>#{feed}<<<<<<<<<"
		#puts ">>>doc>>>>>>>#{doc}<<<<<<<<<"

		puts ">>>Count>>>>>>>#{count}<<<<<<<<<"
		puts ">>>doc.at_css>>>>>>>#{doc.at_css(".fiction-title")}<<<<<<<<<"
		
		if doc.at_css(".fiction-title") != nil

			if count != 0

				title = doc.at_css(".fiction-title").text
				description = doc.at_css(".description").text

				puts ">>>>title>>>>#{title}<<<<<"
				puts ">>>>description>>>>#{description}<<<<<"

				@lightnovel = Lightnovel.create :name => title, :description => description, :home_url => url_nok

				puts ">>>>lightnovel_id>>>>#{@lightnovel.id}<<<<<<"


				@lightnovel.save

				puts ">>>>>>>>lightnovel_saved<<<<<<"

				@lightnovel_n = Lightnovel.find_by(name: title)

				lightnovel_id = @lightnovel_n.id

				chapter_number = 1
				

				puts ">>>>>>>>chapter_init>>>#{chapter_number}<<<<<<"

				puts ">>>>>>>>lightnovel_id>>>#{lightnovel_id}<<<<<<"

				feed_count = feed.entries.count
				puts ">>>>>>>>feedcount>>>>#{feed_count}<<<<<"

				# feed.entries.reverse_each do |f|
				for cc in 0..0
				f=feed.entries.last
				
				
					chapter_name = f.title
					chapter_url = f.url

					puts ">>>>>>>>chapter_name>>>>#{chapter_name}<<<<<"
					puts ">>>>>>>>chapter_url>>>>#{chapter_url}<<<<<"
					puts ">>>>>>>>@lightnovel.id>>>>#{@lightnovel.id}<<<<<"

					@chapter = Chapter.create :lightnovel => @lightnovel, :chapter_name => chapter_name, :chapter_number => chapter_number, :chapter_url => chapter_url, :raws_url => "nil"
					@chapter.save

					chapter_number = chapter_number + 1
				end
			end
		end
	end
end


