class LightnovelsController < ApplicationController
	before_action :set_lightnovel, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!


	def home
		if user_signed_in
		end

		
	end


	def index
		logger.debug ">>>>>>>>>>>lightnovel-index<<<<<<<<<<"
		@lightnovels = Lightnovel.search(params[:search]).order('LOWER(name)').paginate(:per_page => 20, :page => params[:page])
	end

	def show
		# @lightnovel set by privat method
		@chapters = @lightnovel.chapters.order(chapter_number: :desc)
		CheckLatestChapter.perform_async(@chapters.first.chapter_number, @lightnovel.id)
	end

	def edit

	end

	def new
		logger.debug ">>>>>>>>>>>lightnovel-new<<<<<<<<<<"
		@lightnovel = Lightnovel.new
		@chapter = @lightnovel.chapters.build
	end

	def create
		@lightnovel = Lightnovel.new(lightnovel_params)
		logger.debug ">>>>lightnovel-create>>>>>>>#{@lightnovel.name}<<>>>>>>>>#{@lightnovel.id}<<<<<"
		if @lightnovel.save
			redirect_to @lightnovel, notice: 'Lightnovel and Chapter were successfully created.'
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
			params.require(:lightnovel).permit(:name, :description, :home_url, :is_translated, :raws_url, chapter_attribute: [:chapter_number, :chapter_name, :chapter_url])
		end
end
