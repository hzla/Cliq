namespace :interests do
  desc "Generate interest suggestions from interest"
  task :index => :environment do
    InterestSuggestion.index_interests
  end
end