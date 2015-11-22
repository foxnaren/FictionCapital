class AddToUnread
    include Sidekiq::Worker
    
    def perform(lightnovel_id, chapter_id)
    
        @lightnovel = Lightnovel.find(lightnovel_id)
        @chapter = Chapter.find(chapter_id)
        
        @all_users = @lightnovel.users
        
        @all_users.each do |user|
            
            Unread.create(user: user, chapter: @chapter, lightnovel_name: @chapter.lightnovel_name)
            
        end
        
    end
    
end