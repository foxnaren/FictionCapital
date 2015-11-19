
desc "Used to seed database"
task :seed_all => :environment do
	# This is a rake task to seed database asynchronously
	SeedLightnovelRoyalroadl.perform_async(0)
	SeedLightnovelMangareader.perform_async
end