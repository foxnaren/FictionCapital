class LightnovelsController < ApplicationController

	before_action :authenticate_user!
	# before_action :set_user
	# :edit,
	before_action :set_lightnovel, only: [:show, :update, :destroy, :follow, :unfollow]

	def home
		
		@all_followed = current_user.lightnovels
		@all_unread = current_user.chapters

	end

	def follow
		if Follow.find_by(user: current_user, lightnovel: @lightnovel).nil?
			Follow.create(user: current_user, lightnovel: @lightnovel)
		end
		redirect_to @lightnovel, notice: "You have followed #{@lightnovel.name}"
	end

	def unfollow
		unless Follow.find_by(user: current_user, lightnovel: @lightnovel).nil?
			Follow.find_by(user: current_user, lightnovel: @lightnovel).destroy
		end
		redirect_to @lightnovel, notice: "You have unfollowed #{@lightnovel.name}"
	end

	def index
		logger.debug ">>>>>>>>>>>lightnovel-index<<<<<<<<<<"
		@lightnovels = Lightnovel.search(params[:search]).order('LOWER(name)').paginate(:per_page => 20, :page => params[:page])
	end

	def show
		# @lightnovel set by privat method
		@chapters = @lightnovel.chapters.order(chapter_number: :desc)
		check_follow
		if ((Time.parse(Time.now.to_s) - Time.parse(@lightnovel.last_modified.to_s))/3600) > 1
			logger.debug "+++++++++++Task Scheduled+++++#{((Time.parse(Time.now.to_s) - Time.parse(@lightnovel.last_modified.to_s))/3600)}++++++"
			CheckLatestChapter.perform_async(@chapters.first.chapter_number, @lightnovel.id)
		# end
		else
		logger.debug "+++++++++++Task Scheduled NOT++++#{((Time.parse(Time.now.to_s) - Time.parse(@lightnovel.last_modified.to_s))/3600)}+++++++"
		end
	end

	# def edit
	# 	@chapter = @lightnovel.chapters.last
	# end

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
		
		# def set_user
		# 	@user = current_user
		# 	logger.debug ">>>>set_user>>>>>>>#{current_user}<<<<<<#{@user}<<#{user_signed_in?}<<"	
		# end
		def set_lightnovel
			@lightnovel = Lightnovel.find(params[:id])	
			logger.debug ">>>>set_lightnovel>>>>>>>#{@lightnovel.name}<<<<<<<<<<"		
		end
		
		def check_follow
			@followed = current_user.lightnovels.find_by(id: @lightnovel.id)
		end

		def lightnovel_params
			logger.debug ">>>>lightnovel_params>>>>>>>#{params[:lightnovel]}<<<<<<<<<<"
			params.require(:lightnovel).permit(:name, :description, :home_url, :is_translated, :raws_url, :number_of_chapters, :selector_next_chapter, :selector_name, :lightnovel_type, chapter_attribute: [:chapter_number, :chapter_name, :chapter_url])
		end
end
