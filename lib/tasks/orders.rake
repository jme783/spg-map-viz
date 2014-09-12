require 'Sprig/orders/importer'

namespace :orders do
  desc "Imports the Sprig orders"
  task :import_order_data => :environment do
    importer = Sprig::Orders::Importer.new "./lib/data/orders.csv"
    importer.import_order_data!
  end
end
