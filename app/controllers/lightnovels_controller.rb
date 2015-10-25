class LightnovelsController < ApplicationController
	before_action :set_lightnovel, only: [:show, :edit, :update, :destroy]

	def index
		logger.debug ">>>>>>>>>>>lightnovel-index<<<<<<<<<<"
		@lightnovels = Lightnovel.order('LOWER(name)')
	end

	def show
		# @lightnovel set by privat method
		@chapters = @lightnovel.chapters
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
			for @populate_chapter in 0...@lightnovel.total_number_of_chapters 
				logger.debug ">>>>lightnovel-create>>>@populate_chapter>>>>#{@populate_chapter}<<<<<<<<<<"
				create_chapters
			end
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
			params.require(:lightnovel).permit(:name, :description, :total_number_of_chapters, :raws_url, :is_translated, :translated_chapters, :translated_url)
		end

		def create_chapters
			logger.debug ">>>>chapter_params>>>lightnovel.id>>>>#{@lightnovel}<<<<<<<<<<"
			lightnovel_id = @lightnovel.id
			logger.debug ">>>>chapter_params>>>lightnovel_id>>>>#{lightnovel_id}<<<<<<<<<<"
			chapter_name = "-"
			logger.debug ">>>>chapter_params>>>>>>>#{@lightnovel.chapters.pluck(:chapter_number).last}<<<<<<<<<<"
			if (@lightnovel.chapters.pluck(:chapter_number).last).present?
				chapter_number = @lightnovel.chapters.pluck(:chapter_number).last + 1
			else
				chapter_number = 1;
			end
			logger.debug ">>>>chapter_params>>>>>>>#{chapter_number}<<<<<<<<<<"
			raws_url = @lightnovel.raws_url
			if @lightnovel.is_translated == true
				translated_url = @lightnovel.translated_url
			else
				translated_url = @lightnovel.raws_url
			end
			logger.debug ">>>>chapter_params>>>>>>>#{params[:chapter]}<<<<<<<<<<"
		
			@chapter = Chapter.new(:lightnovel_id => lightnovel_id, :chapter_name => chapter_name, :chapter_number => chapter_number, :raws_url => raws_url, :translated_url => translated_url)
			@chapter.save
		end

end
