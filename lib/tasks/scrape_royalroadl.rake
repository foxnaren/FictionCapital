desc "Fetch Royalroadl Links"
task :fetch_royalroadl => :environment do

	require 'rubygems'
	require 'feedjira'
	require 'nokogiri'
	require 'open-uri'

	fictionID = 300
	total_royalroadl_fiction = fictionID +100

	
	while (total_royalroadl_fiction-fictionID) > 0
		fictionID = fictionID+1
		# puts ">>>>>>>>#{fictionID}>>#{total_royalroadl_fiction-fictionID}<<<<"
	#for fictionID in 1..total_royalroadl_fiction
		
		url_feed = "http://royalroadl.com/forum/syndication.php?fid=#{fictionID}"
		url_nok = "http://royalroadl.com/fiction/#{fictionID}"

		if Lightnovel.find_by(home_url: url_nok).nil?

			puts "++++++++#{fictionID}>>#{total_royalroadl_fiction}+++++++++"
			# puts ">>>>>url-feed>>>#{url_feed}<<<<"
			# puts ">>>>url-nok>>>#{url_nok}<<<<<"
			
			feed = Feedjira::Feed.fetch_and_parse url_feed
			doc = Nokogiri::HTML(open(url_nok))
			
			count = feed.entries.count

			#puts ">>>feed>>>>>>>#{feed}<<<<<<<<<"
			#puts ">>>doc>>>>>>>#{doc}<<<<<<<<<"

			# puts ">>>Count>>>>>>>#{count}<<<<<<<<<"
			# puts ">>>doc.at_css>>>>>>>#{doc.at_css(".fiction-title")}<<<<<<<<<"
			
			if doc.at_css(".fiction-title") != nil

				if count != 0

					title = doc.at_css(".fiction-title").text
					description = doc.at_css(".description").text

					# puts ">>>>title>>>>#{title}<<<<<"
					# puts ">>>>description>>>>#{description}<<<<<"

					@lightnovel = Lightnovel.create :name => title, :description => description, :home_url => url_nok

					# puts ">>>>lightnovel_id>>>>#{@lightnovel.id}<<<<<<"


					# @lightnovel.save

					# puts ">>>>>>>>lightnovel_saved<<<<<<"

					@lightnovel_n = Lightnovel.find_by(home_url: url_nok)

						puts "test"
					puts ">>>>lightnovel_id>>>>#{@lightnovel_n.id}<<<<<<"


					lightnovel_id = @lightnovel_n.id

					chapter_number = 1
					

					# puts ">>>>>>>>chapter_init>>>#{chapter_number}<<<<<<"

					# puts ">>>>>>>>lightnovel_id>>>#{lightnovel_id}<<<<<<"

					feed_count = feed.entries.count
					# puts ">>>>>>>>feedcount>>>>#{feed_count}<<<<<"

					feed.entries.reverse_each do |f|
					# for cc in 0..0
					# f=feed.entries.last
					
					
						chapter_name = f.title
						chapter_url = f.url

						# puts ">>>>>>>>chapter_name>>>>#{chapter_name}<<<<<"
						# puts ">>>>>>>>chapter_url>>>>#{chapter_url}<<<<<"
						# puts ">>>>>>>>@lightnovel.id>>>>#{@lightnovel.id}<<<<<"

						@chapter = Chapter.create :lightnovel => @lightnovel, :chapter_name => chapter_name, :chapter_number => chapter_number, :chapter_url => chapter_url, :raws_url => "nil"
						# @chapter.save

						chapter_number = chapter_number + 1


					end
					if (total_royalroadl_fiction-fictionID)<=50
						total_royalroadl_fiction = total_royalroadl_fiction +50
					end
				end
			end
		else
			puts "*******#{fictionID}>>#{total_royalroadl_fiction}******"
			if (total_royalroadl_fiction-fictionID)<=50
				total_royalroadl_fiction = total_royalroadl_fiction + 50
			end
		end
	end
end


