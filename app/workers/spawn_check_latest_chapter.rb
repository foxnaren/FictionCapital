require 'rubygems'
require 'nokogiri'
require 'open-uri'

class SeedLightnovelRoyalroadl
    include Sidekiq::Worker

    def perform(time_in_hours)
    	

    	oldest_time = (Time.now.to_s)/3600 - time_in_hours.hours.ago

    	@lightnovel = Lightnovel.where("last_modified > ?", params[:oldest_time])




    		Movie.where(['release > ?', DateTime.now])


    		

    end
end
