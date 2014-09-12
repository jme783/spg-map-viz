require 'Sprig/hubs/importer'

namespace :hubs do
  desc "Imports the Sprig hubs"
  task :import_hub_data => :environment do
    importer = Sprig::Hubs::Importer.new "./lib/data/hubs.csv"
    importer.import_hub_data!
  end
end
