class AddToUnread
    include Sidekiq::Worker
    
    def perform(lightnovel_id, chapter_id)
    
        @lightnovel = Lightnovel.find(lightnovel_id)
        @chapter = Chapter.find(chapter_id)

        logger.info "Entered add #{@lightnovel.id} and #{@chapter.id}"
        
        @all_users = @lightnovel.users

     
        @all_users.each do |user|
            
            Unread.create(user: user, chapter: @chapter)
            logger.info "Unread created for #{user.id} and #{@chapter.id}"
            
        end
        
    end
    
end