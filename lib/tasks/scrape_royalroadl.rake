desc "Fetch Royalroadl Links"
task :fetch_royalroadl => :environment do

	require 'rubygems'
	require 'feedjira'
	require 'nokogiri'
	require 'open-uri'

	for fictionID in 3917..3917
		
		url_feed = "http://royalroadl.com/forum/syndication.php?fid=#{fictionID}"
		url_nok = "http://royalroadl.com/fiction/#{fictionID}"
		
		feed = Feedjira::Feed.fetch_and_parse url_feed
		doc = Nokogiri::HTML(open(url_nok))
		
		count = feed.entries.count
		
		if count != 0

			title = doc.at_css(".fiction-title").text
			description = doc.at_css(".description").text

			@lightnovel = Lightnovel.create :name => title, :description => description, :home_url => url_nok
			@lightnovel.save
			
			chapter_number = 1

			feed.entries.reverse_each do |feed|
				chapter_name = feed.title
				chapter_url = feed.url

				@chapter = Chapter.create :lightnovel => @lightnovel.id, :chapter_name => chapter_name, :chapter_number => chapter_number, :chapter_url => chapter_url
				@chapter.save

				chapter_number = chapter_number + 1
			end
		end
	end
end

