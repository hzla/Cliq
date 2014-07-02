namespace :location_suggestions do
  desc "Generate location suggestions from locations"
  task :index => :environment do
    LocationSuggestion.index_locations
  end
end