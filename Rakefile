require 'bundler/gem_tasks'

def specs(dir)
  FileList["spec/#{dir}/*_spec.rb"].shuffle.join(' ')
end

desc 'Runs all the specs'
task :specs do
  sh "bundle exec bacon #{specs('**')}"
end

task :default => :specs


task :test do
  require 'aws-sdk-s3'
  Aws.config.update(
    endpoint: 'http://172.16.9.3:9000',
    access_key_id: 'minioadmin',
    secret_access_key: 'minioadmin',
    force_path_style: true,
    region: 'bj-zealot-1'
  )

  zip_name = 'ios-84bce11decf8e7e64c3daf46f487c0d4bd6125bd.zip'
  s3 = Aws::S3::Resource.new
  obj = s3.bucket('cocoapods').object(zip_name)

  if !obj.exists?
    puts "Item does not exist in cache"
    exit
  end

  puts "Downloading #{zip_name}： #{obj.last_modified}·"
  success = obj.get(response_target: zip_name)#(zip_name)
  if !success
    puts "An error occurred attempt to download the cache item"
    exit
  end
end
