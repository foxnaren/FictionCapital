class LightnovelsController < ApplicationController

	before_action :authenticate_user!, except: [:home]
	# before_action :set_user
	# :edit,
	before_action :set_lightnovel, only: [:show, :update, :destroy, :follow, :unfollow]
	before_action :set_unread_count

	def home
		@latest_lightnovels = Lightnovel.last(20)
		@latest_chapters = Chapter.last(20)
		@user = current_user
		# need to add comments and reviews here
	end

	def unread
		# @disp_name = nil
	end

	def mark_as_read
		if params[:range] == "chapter"
			read = Unread.find_by(user: current_user, chapter: params[:id]).destroy
		else
			read = Unread.where(lightnovel_name: params[:lightnovel_name])
			unless read.blank?
				read.each do |r|
					r.destroy
				end
			end
		end

		redirect_to :back, notice: "Marked as Read"
		
	end

	def followed
		@all_followed = current_user.lightnovels.order('LOWER(name)').paginate(:per_page => 40, :page => params[:page])
	end

	def follow
		if Follow.find_by(user: current_user, lightnovel: @lightnovel).nil?
			Follow.create(user: current_user, lightnovel: @lightnovel)
		end
		redirect_to :back, notice: "You have followed #{@lightnovel.name}"
	end

	def unfollow
		unfollow = Follow.find_by(user: current_user, lightnovel: @lightnovel)
		unless unfollow.nil?
			unfollow.destroy
		end
		redirect_to :back, notice: "You have unfollowed #{@lightnovel.name}"
	end

	def render_chapter

		@link = params[:chapter_url]

 		unless @link.include?("http://") || @link.include?("https://")
  			@link.insert(0, "http://")
 		end	

 		redirect_to @link
	end

	def index
		logger.debug ">>>>>>>>>>>lightnovel-index<<<<<<<<<<"
		@lightnovels = Lightnovel.search(params[:search]).order('LOWER(name)').paginate(:per_page => 40, :page => params[:page])
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
		
		def set_lightnovel
			@lightnovel = Lightnovel.find(params[:id])	
			logger.debug ">>>>set_lightnovel>>>>>>>#{@lightnovel.name}<<<<<<<<<<"		
		end

		def set_unread_count
			if user_signed_in?
				@all_unread = current_user.chapters.order(lightnovel_name: :desc, chapter_number: :asc).paginate(:per_page => 40, :page => params[:page])
			# @all_unread_first = @all_unread.first
				@all_unread_count = @all_unread.count
			end
		end
		
		def check_follow
			@followed = current_user.lightnovels.find_by(id: @lightnovel.id)
		end

		def lightnovel_params
			logger.debug ">>>>lightnovel_params>>>>>>>#{params[:lightnovel]}<<<<<<<<<<"
			params.require(:lightnovel).permit(:name, :description, :home_url, :is_translated, :raws_url, :number_of_chapters, :lightnovel_type, :selector_next_chapter, :selector_name, :lightnovel_type, chapter_attribute: [:lightnovel_name, :chapter_number, :chapter_name, :chapter_url])
		end
end
