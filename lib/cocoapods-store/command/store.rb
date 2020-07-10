require 'aws-sdk-s3'
require 'cocoapods-store/command/store/push'
require 'cocoapods-store/command/store/pull'

module Pod
  class Command

    # This is an example of a cocoapods plugin adding a top-level subcommand
    # to the 'pod' command.
    #
    # You can also create subcommands of existing or new commands. Say you
    # wanted to add a subcommand to `list` to show newly deprecated pods,
    # (e.g. `pod list deprecated`), there are a few things that would need
    # to change.
    #
    # - move this file to `lib/pod/command/list/deprecated.rb` and update
    #   the class to exist in the the Pod::Command::List namespace
    # - change this class to extend from `List` instead of `Command`. This
    #   tells the plugin system that it is a subcommand of `list`.
    # - edit `lib/cocoapods_plugins.rb` to require this file
    #
    # @todo Create a PR to add your plugin to CocoaPods/cocoapods.org
    #       in the `plugins.json` file, once your plugin is released.
    #
    class Store < Command

			self.description = "Manage a pod installation store"

			self.abstract_command = true


			def self.options
				[
          ['--server',			'The AWS server address.'	],
					['--bucket',			'The bucket to use as the store.'	],
					['--aws-key',			'Your AWS access key ID.'					],
					['--aws-secret',	'Your AWS secret access key.'			]
				]
			end

			def initialize(argv)
				super

				prefs_file = '.cocoapods-store.yml'
				prefs = (File.exist?(prefs_file) && YAML.load_file(prefs_file)) || {}

				@server = argv.option('server', nil) || prefs['server']
				@bucket = argv.option('bucket', nil) || prefs['bucket']
				@aws_public_key = argv.option('aws-key', nil) || prefs['aws-key']
				@aws_private_key = argv.option('aws-secret', nil) || prefs['aws-secret']
		end

			def validate!
				super

        help! "A AWS server must be specified using --server" unless @server
				help! "A bucket must be specified using --bucket" unless @bucket
				help! "An AWS access key ID must be specified using --aws-key" unless @aws_public_key
				help! "An AWS secret access key must be specified using --aws-secret" unless @aws_private_key
			end

			# Methods

      def load_s3_bucket
        Aws.config.update(
          endpoint: 'http://172.16.9.3:9000',
          access_key_id: 'minioadmin',
          secret_access_key: 'minioadmin',
          force_path_style: true,
          region: 'bj-zealot-1'
        )

				return Aws::S3::Resource.new
			end

			# Accessors

			def commit
				return `git rev-parse HEAD`
			end

			def project_name
				return Pathname.new(Dir.pwd).basename
			end

			def	cache_dir_name
				return "#{project_name}-#{commit.strip!}"
			end

		end
  end
end
