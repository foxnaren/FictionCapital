class ChaptersController < ApplicationController
	before_filter :find_lightnovel
	before_action :set_chapter, only: [:show, :edit, :update, :destroy]

	def show

	



	end



	private

		def set_chapter

		end

		def find_lightnovel
      		logger.debug ">>>>>>find_lightnovel>>>>>>>>#{params[:lightnovel_id]}<<<<<<<<<<<<<<"
       		@lightnovel = Lightnovel.find(params[:lightnovel_id])
       		logger.debug ">>>>>>find_lightnovel>>>>>>>>#{@lightnovel}<<<<<<<<<<<<<<"
    	end

end




