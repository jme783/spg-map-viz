module Sprig
  module Hubs
    class Importer
      def initialize path
        @path = path
      end

      def import_hub_data!
        CSV.foreach(@path, headers: true, return_headers: false) do |row|
          @row = row
          @hub = Hub.create! row.to_hash
          @hub ? (puts "Hub  with id #{@hub.id} successfully added") : (puts "Error in adding hub with id #{@hub.id}")
        end
      end
    end
  end
end
