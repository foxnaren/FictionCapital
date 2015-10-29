class ChaptersController < ApplicationController
	before_filter :find_lightnovel
	before_action :set_chapter, only: [:show, :edit, :update, :destroy]

	def show

	



	end


	def next

		# ***********************change var*********************
		current_chapter_number = 1


		next_chapter_number = current_chapter_number+1

		if @lightnovel.chapters.find_by(chapter_number: next_chapter_number) == nil

			parse_url
			case home_url_parsed
			when ""
				
			


			


		end


	end	

	private

		def set_chapter

		end

		def find_lightnovel
      		logger.debug ">>>>>>find_lightnovel>>>>>>>>#{params[:lightnovel_id]}<<<<<<<<<<<<<<"
       		@lightnovel = Lightnovel.find(params[:lightnovel_id])
       		logger.debug ">>>>>>find_lightnovel>>>>>>>>#{@lightnovel}<<<<<<<<<<<<<<"
    	end

    	def parse_url
    		home_url = URI.parse(@lightnovel.home_url)
			home_url_parsed = "{uri.host}" 
		end

end




