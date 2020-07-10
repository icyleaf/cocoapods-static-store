
require 'yaml'

module Pod
  class Command
		class Store < Command

			class Pull < Store

				self.summary = 'Pulls down and integrates installation data.'

        self.description = <<-DESC
          Pulls down and integrates installation data
				DESC

				# Plugin Lifecycle

				def initialize(argv)
					super
				end

				def validate!
					super
				end

				def run

					verify_podfile_exists!

					pull_from_store
					replace_installation_data
				end

				# Run steps

				def pull_from_store
          zip_name = "#{cache_dir_name}.zip"
					s3 = load_s3_bucket
					obj = s3.bucket(@bucket).object(zip_name)

					if !obj.exists?
						UI.puts "Item does not exist in cache"
						exit
					end

					UI.puts "Downloading #{zip_name}"
          success = obj.get(response_target: zip_name)
					if !success
						UI.puts "An error occurred attempt to download the cache item"
						exit
					end
				end

				def replace_installation_data
					zip_name = "#{cache_dir_name}.zip"

					FileUtils.rm_rf "#{Dir.pwd}/Pods"
					FileUtils.rm_rf Dir.glob("#{Dir.pwd}/*.xcworkspace").first || ""
					FileUtils.rm_rf "#{Dir.pwd}/Podfile.lock"

					system "unzip #{zip_name} > /dev/null"

				end

			end

		end
	end
end
