    # this need to be a controller

desc "Add the next chapter"
task :testingthis => :environment do

            # CheckLatestChapter.perform_async(@chapters.first.chapter_number, @lightnovel.id)
            # 
            SeedLightnovelRoyalroadl.perform_async(0)


end