class LightnovelsController < ApplicationController
	before_action :set_lightnovel, only: [:show, :edit, :update, :destroy]

	def index
		logger.debug ">>>>>>>>>>>lightnovel-index<<<<<<<<<<"
		@lightnovels = Lightnovel.order('LOWER(name)')
	end

	def show
		# @lightnovel set by privat method
		@chapters = @lightnovel.chapters.order(chapter_number: :desc)
	end

	def edit

  	end

	def new
		logger.debug ">>>>>>>>>>>lightnovel-new<<<<<<<<<<"
		@lightnovel = Lightnovel.new		
	end

	def create
		@lightnovel = Lightnovel.new(lightnovel_params)
		logger.debug ">>>>lightnovel-create>>>>>>>#{@lightnovel.name}<<<<<<<<<<"
		if @lightnovel.save
        	redirect_to @lightnovel, notice: 'Lightnovel was successfully created.'
        else
        	render :new
		end
	end

	def update
		logger.debug ">>>>lightnovel-update>>>>>>>#{@lightnovel.name}<<<<<<<<<<"
		if @lightnovel.update(lightnovel_params)
        	redirect_to @lightnovel, notice: 'Lightnovel was successfully updated.'
        else
        	render :edit
		end
	end
		
	def destroy
		logger.debug ">>>>lightnovel-destroy>>>>>>>#{@lightnovel.name}<<<<<<<<<<"
		@lightnovel.destroy
       	redirect_to lightnovels_url, notice: "Lightnovel #{@lightnovel.name} was successfully destroyed."
	end

	private

		def set_lightnovel
			@lightnovel = Lightnovel.find(params[:id])	
			logger.debug ">>>>set_lightnovel>>>>>>>#{@lightnovel.name}<<<<<<<<<<"		
		end

		def lightnovel_params
			logger.debug ">>>>lightnovel_params>>>>>>>#{params[:lightnovel]}<<<<<<<<<<"
			params.require(:lightnovel).permit(:name, :description, :home_url, :is_translated, :raws_url)
		end
end
